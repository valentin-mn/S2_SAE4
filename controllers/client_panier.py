#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

client_panier = Blueprint('client_panier', __name__,
                        template_folder='templates')

@client_panier.route('/client/panier/show')      # remplace /client
def client_panier_show():                                 # remplace client_index
    mycursor = get_db().cursor()
    tuple_recup=(session['user_id'])
    recuperation_article = '''SELECT *, quantite*prix_vetement as somme_article FROM panier 
    join vetement on panier.id_vetement=vetement.id_vetement 
    join type_vetement on type_vetement.id_type_vetement=vetement.id_type_vetement 
    join propose p on p.id_vetement= vetement.id_vetement 
    join marque m on m.id_marque=p.id_marque
    join taille on panier.id_taille = taille.id_taille
    where id_users = %s ;'''
    mycursor.execute(recuperation_article,tuple_recup)
    articles = mycursor.fetchall()
    types_articles = []
    articles_panier = []

    #recuperation somme totale
    tuple_recup=(session['user_id'])
    recuperation_somme_totale='''SELECT SUM(quantite*prix_vetement) as somme ,SUM(quantite) as quantite, SUM(quantite*prix_vetement)+SUM(quantite) as total FROM panier join vetement on panier.id_vetement=vetement.id_vetement WHERE id_users = %s'''
    mycursor.execute(recuperation_somme_totale, tuple_recup)
    prix_total = mycursor.fetchone()

    #recuperation adresses
    tuple_recup = (session['user_id'])
    recuperation_somme_totale = '''SELECT * FROM adresse join est_associee_a est on adresse.id_adresse=est.id_adresse WHERE id_users = %s'''
    mycursor.execute(recuperation_somme_totale, tuple_recup)
    adresses = mycursor.fetchall()

    articles_id = []
    articles_requete = articles
    articles_return = []
    i = 0
    for key in articles_requete:
        print(articles_return)
        print(i)
        if (key['id_vetement'] not in articles_id):
            i += 1;
            articles_id.append(key['id_vetement'])
            articles_return.append(key)
        else:
            articles_return[i - 1]['libelle_marque'] += ' x ' + key['libelle_marque']
    return render_template('client/boutique/panier_article.html', articles=articles_return, adresses=adresses, prix_total=prix_total, itemsFiltre=types_articles)



@client_panier.route('/client/panier/add', methods=['GET'])
def client_panier_add():
    mycursor = get_db().cursor()
    quantite = request.args['quantite']
    taille = request.args['taille']
    id_article = request.args['id']
    tuple_select=(id_article,session['user_id'],taille)
    requete='''SELECT * FROM panier where id_vetement = %s AND id_users = %s AND id_taille = %s'''
    mycursor.execute(requete,tuple_select)
    result = mycursor.fetchone()
    if (result):
        quantite = int(result["quantite"]) + int(quantite)
        tuple_insert = (quantite,id_article, session['user_id'],taille)
        delete_panier = '''UPDATE panier set quantite = %s where id_vetement = %s AND id_users = %s AND id_taille = %s'''
        mycursor.execute(delete_panier, tuple_insert)
        get_db().commit()
        message = "Produit ajouté au panier !"
    else :
        tuple_insert = (id_article, session['user_id'],taille,quantite)
        delete_panier = '''INSERT INTO panier VALUES(%s,%s,%s,%s)'''
        mycursor.execute(delete_panier, tuple_insert)
        get_db().commit()
        message = "Produit ajouté au panier !"
    flash(message)
    return redirect('/client/panier/show')
    #return redirect(url_for('client_index'))





@client_panier.route('/client/panier/delete', methods=['GET'])
def client_panier_delete():
    mycursor = get_db().cursor()
    id_article = request.args['id']
    id_taille = request.args['taille']
    tuple_delete=(id_article,session['user_id'],id_taille)
    delete_panier = '''delete from panier where id_vetement=%s and id_users=%s and id_taille=%s'''
    mycursor.execute(delete_panier,tuple_delete)
    get_db().commit()
    flash(u'Article supprimé')
    return redirect('/client/panier/show')
    #return redirect(url_for('client_index'))


@client_panier.route('/client/panier/ajout_adresse', methods=['POST'])
def add_adresse():
    mycursor = get_db().cursor()
    ligne1 = request.form.get('ligne1')
    ligne2 = request.form.get('ligne2')
    ville = request.form.get('ville')
    CP = request.form.get('CP')
    pays = request.form.get('pays')
    tuple_insert = (ligne1,ligne2,ville,CP,pays)
    add_adresse = '''INSERT INTO adresse VALUES(NULL,%s,%s,%s,%s,%s)'''
    mycursor.execute(add_adresse, tuple_insert)
    get_db().commit()

    #recuperartion de la derniere adresse
    recup_adresse = '''SELECT * FROM adresse ORDER BY id_adresse DESC LIMIT 1'''
    mycursor.execute(recup_adresse)
    result = mycursor.fetchone()
    id=result["id_adresse"]

    #insertion est_associee_a
    tuple_insert = (session['user_id'],id)
    add_est_associee_a = '''INSERT INTO est_associee_a VALUES(%s,%s)'''
    mycursor.execute(add_est_associee_a, tuple_insert)
    get_db().commit()





    return redirect('/client/panier/show')
    #return redirect(url_for('client_index'))


@client_panier.route('/client/panier/commander', methods=['POST'])
def client_panier_commander():
    message=''
    mycursor = get_db().cursor()



    #recuperation id_commande
    recup_commande = '''SELECT * FROM commande ORDER BY id_commande DESC LIMIT 1'''
    mycursor.execute(recup_commande)
    result = mycursor.fetchone()
    id=result["id_commande"]

    #recuperation nb articles panier
    tuple_recup = ( session['user_id'])
    recup_commande = '''select count(*) from panier where id_users = %s;'''
    mycursor.execute(recup_commande,tuple_recup)
    result = mycursor.fetchone()
    nb = result["count(*)"]

    #verification disponibilité articles
    dispo=[]
    for i in range(nb):
        tuple_recup = (session['user_id'],i)
        recup_commande = '''select * from panier join vetement v on panier.id_vetement = v.id_vetement WHERE id_users = %s LIMIT %s, 1'''
        mycursor.execute(recup_commande, tuple_recup)
        result = mycursor.fetchone()
        tuple_select = (result["id_vetement"],result["id_taille"])
        requete='''SELECT * FROM est_dispo WHERE id_vetement = %s AND id_taille=%s'''
        mycursor.execute(requete,tuple_select)
        quantite_dispo=int(mycursor.fetchone()['stock'])
        if (int(result["quantite"]) <= quantite_dispo):
            dispo.append(True)
        else :
            dispo.append(False)

    if (False not in dispo):
        id_adresse = request.form.get('adresse')
        tuple_insert = (id_adresse, session['user_id'])
        add_est_associee_a = '''INSERT INTO commande VALUES(NULL, date(now()), %s, %s, 1);'''
        mycursor.execute(add_est_associee_a, tuple_insert)
        get_db().commit()
        for i in range(nb):
            tuple_recup = (session['user_id'], i)
            recup_commande = '''select * from panier join vetement v on panier.id_vetement = v.id_vetement WHERE id_users = %s LIMIT %s, 1'''
            mycursor.execute(recup_commande, tuple_recup)
            result = mycursor.fetchone()
            tuple_insert = (result["id_vetement"],id,result["id_taille"],result["prix_vetement"],result["quantite"])
            add_est_associee_a = '''INSERT INTO ligne_commande VALUES(%s,%s,%s,%s,%s)'''
            mycursor.execute(add_est_associee_a, tuple_insert)
            quantite_dispo = quantite_dispo - int(result["quantite"])
            tuple_update=(quantite_dispo,result["id_vetement"],result["id_taille"])
            requete = '''UPDATE est_dispo set stock=%s WHERE id_vetement = %s AND id_taille=%s'''
            mycursor.execute(requete,tuple_update)
            get_db().commit()
            tuple_delete = (session['user_id'])
            delete_panier = '''DELETE FROM panier where id_users=%s'''
            mycursor.execute(delete_panier, tuple_delete)
            get_db().commit()
            message='Commande passée, rendez vous dans l\'onglet "Mes commandes"'
    else :
        probleme = dispo.index(False)
        tuple_recup = (session['user_id'], probleme)
        recup_commande = '''select * from panier join vetement v on panier.id_vetement = v.id_vetement WHERE id_users = %s LIMIT %s, 1'''
        mycursor.execute(recup_commande, tuple_recup)
        result = mycursor.fetchone()
        tuple_select = (result["id_vetement"], result["id_taille"])
        requete = '''SELECT * FROM est_dispo join taille on taille.id_taille=est_dispo.id_taille WHERE id_vetement = %s AND est_dispo.id_taille=%s'''
        mycursor.execute(requete, tuple_select)
        resultat = mycursor.fetchone()
        print(resultat)
        message= result["libelle_vetement"] + " (" + resultat['libelle_taille'] + ") n'est disponibles qu'en " + str(resultat['stock']) + " exemplaire(s)."




    flash(message)
    return redirect('/client/panier/show')
    #return redirect(url_for('client_index'))




@client_panier.route('/client/panier/filtre', methods=['POST'])
def client_panier_filtre():
    # SQL
    filter_word = request.form.get('filter_word', None)
    filter_prix_min = request.form.get('filter_prix_min', None)
    filter_prix_max = request.form.get('filter_prix_max', None)
    filter_types = request.form.getlist('filter_types', None)
    filter_sex = request.form.getlist('filter_sex', None)
    filter_marque = request.form.getlist('filter_marque', None)


    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))


@client_panier.route('/client/panier/filtre/suppr', methods=['POST'])
def client_panier_filtre_suppr():
    session.pop('filter_word', None)
    session.pop('filter_prix_min', None)
    session.pop('filter_prix_max', None)
    session.pop('filter_types', None)
    print("suppr filtre")
    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))
