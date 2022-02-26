#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

client_article = Blueprint('client_article', __name__,
                        template_folder='templates')

@client_article.route('/client/index')
@client_article.route('/client/article/show')
def client_article_show():
    mycursor = get_db().cursor()
    recuperation_article = '''SELECT DISTINCT vetement.id_vetement,libelle_vetement,libelle_marque,prix_vetement FROM vetement
    left join type_vetement on type_vetement.id_type_vetement=vetement.id_type_vetement
    left join propose p on p.id_vetement= vetement.id_vetement
    left join marque m on m.id_marque=p.id_marque
    right join est_dispo on est_dispo.id_vetement=vetement.id_vetement'''

    # gestion des filtres
    list_param = []
    condition_and = ""
    if "filter_word" in session or "filter_prix_min" in session or "filter_prix_max" in session or "filter_types" in session or "filter_tailles" in session or "filter_sexes" in session:
        recuperation_article = recuperation_article + " WHERE "
        if "filter_word" in session:
            recuperation_article = recuperation_article + " vetement.libelle_vetement LIKE %s or libelle_marque LIKE %s"
            recherche = "%" + session["filter_word"] + "%"
            list_param.append(recherche)
            list_param.append(recherche)
            condition_and = " AND "
        if "filter_prix_min" in session or "filter_prix_max" in session:
            recuperation_article = recuperation_article + condition_and + " vetement.prix_vetement BETWEEN %s AND %s "
            list_param.append(session["filter_prix_min"])
            list_param.append(session["filter_prix_max"])
            condition_and = " AND "
        if "filter_types" in session:
            recuperation_article = recuperation_article + condition_and + "("
            last_item = session['filter_types'][-1]
            for item in session['filter_types']:
                recuperation_article = recuperation_article + " vetement.id_type_vetement = %s "
                if item != last_item:
                    recuperation_article = recuperation_article + " or "
                list_param.append(item)
            recuperation_article = recuperation_article + ")"
        if "filter_tailles" in session:
            recuperation_article = recuperation_article + condition_and + "("
            last_item = session['filter_tailles'][-1]
            for item in session['filter_tailles']:
                recuperation_article = recuperation_article + " est_dispo.id_taille = %s "
                if item != last_item:
                    recuperation_article = recuperation_article + " or "
                list_param.append(item)
            recuperation_article = recuperation_article + ")"
        if "filter_sexes" in session:
            recuperation_article = recuperation_article + condition_and + "("
            last_item = session['filter_sexes'][-1]
            for item in session['filter_sexes']:
                recuperation_article = recuperation_article + " vetement.id_sexe = %s "
                if item != last_item:
                    recuperation_article = recuperation_article + " or "
                list_param.append(item)
            recuperation_article = recuperation_article + ")"


    print(recuperation_article,tuple(list_param))
    mycursor.execute(recuperation_article,tuple(list_param))
    articles = mycursor.fetchall()
    articles_panier = []
    articles_id = []
    articles_requete = articles
    articles_return = []
    i = 0
    for key in articles_requete:
        if (key['id_vetement'] not in articles_id):
            articles_id.append(key['id_vetement'])
            articles_return.append(key)
            i += 1;
        else:
            articles_return[i - 1]['libelle_marque'] += ' x ' + key['libelle_marque']
    prix_total = None

    tailles = '''SELECT * FROM taille '''
    mycursor.execute(tailles)
    tailles = mycursor.fetchall()


    #necessaire au filtre
    recuperation_type_article = '''SELECT * FROM type_vetement order by libelle_type_vetement '''
    mycursor.execute(recuperation_type_article)
    types_articles = mycursor.fetchall()
    recuperation_sexe = '''SELECT * FROM sexe '''
    mycursor.execute(recuperation_sexe)
    sexes = mycursor.fetchall()

    return render_template('client/boutique/show_articles.html', articles=articles_return, articlesPanier=articles_panier,
                           prix_total=prix_total, itemsFiltreType=types_articles, tailles=tailles, sexes = sexes)




@client_article.route('/client/article/details/<int:id>', methods=['GET'])
def client_article_details(id):
    mycursor = get_db().cursor()
    tuple_recup = (id)
    article='''SELECT * FROM vetement
    join type_vetement on type_vetement.id_type_vetement = vetement.id_type_vetement
    WHERE id_vetement=%s'''
    mycursor.execute(article, tuple_recup)
    article = mycursor.fetchone()
    proposed='''SELECT * FROM vetement  
    join type_vetement on type_vetement.id_type_vetement=vetement.id_type_vetement 
    join propose p on p.id_vetement= vetement.id_vetement 
    join marque m on m.id_marque=p.id_marque WHERE vetement.id_vetement != %s 
    LIMIT 1,4'''
    mycursor.execute(proposed,tuple_recup)
    proposed = mycursor.fetchall()
    tailles='''SELECT * FROM taille 
    join est_dispo ed on ed.id_taille = taille.id_taille
    WHERE id_vetement = %s'''
    mycursor.execute(tailles, tuple_recup)
    tailles=mycursor.fetchall()
    commentaires = '''SELECT * FROM commentaires 
       join users u on u.id_users = commentaires.id_users
       WHERE id_vetement = %s'''
    mycursor.execute(commentaires, tuple_recup)
    commentaires = mycursor.fetchall()
    stat_comment = '''select avg(note_commentaire) as avg, count(note_commentaire) as count from commentaires WHERE id_vetement = %s;'''
    mycursor.execute(stat_comment,tuple_recup)
    stat_comment = mycursor.fetchone()
    if (stat_comment['count'] < 1):
        stat_comment['count'] = 0
        stat_comment['avg']='--'
    else:
        stat_comment['avg'] = round(stat_comment['avg'], 1)


    matieres = ''' select * from est_en 
    join matiere m on m.id_matiere=est_en.id_matiere 
    where id_vetement=%s;'''
    mycursor.execute(matieres,tuple_recup)
    matieres = mycursor.fetchall()

    marque = ''' SELECT * FROM propose 
    JOIN  marque m on m.id_marque = propose.id_marque
    WHERE id_vetement = %s'''
    mycursor.execute(marque, tuple_recup)
    marques = mycursor.fetchall()


    #traitement des articles
    articles_id = []
    articles_requete = proposed
    articles_return = []
    i = 0
    for key in articles_requete:

        if (key['id_vetement'] not in articles_id):
            articles_id.append(key['id_vetement'])
            articles_return.append(key)
            i += 1;
        else:
            articles_return[i - 1]['libelle_marque'] += ' x ' + key['libelle_marque']


    return render_template('client/boutique/single_product.html',marques=marques, matieres=matieres,stat_comment = stat_comment, article=article, commentaires=commentaires, proposed=articles_return, id=id,tailles=tailles)



@client_article.route('/client/article/filtre', methods=['POST'])
def client_article_filtre():
    filter_word = request.form.get('filter_word', None)
    filter_prix_min = request.form.get('filter_prix_min', None)
    filter_prix_max = request.form.get('filter_prix_max', None)
    filter_types = request.form.getlist('filter_types', None)
    filter_sexes = request.form.getlist('filter_sexes', None)
    filter_tailles = request.form.getlist('filter_tailles', None)

    if filter_word or filter_word == '':
        if len(filter_word) > 1:
            if filter_word.isalpha():
                session['filter_word'] = filter_word
            else:
                flash(u'votre Mot recherché doit uniquement être composé de lettres')
        else:
            if len(filter_word) == 1:
                flash(u'votre Mot recherché doit être composé d\'au moins 2 lettres')
            else:
                session.pop('filter_word', None)

    if filter_prix_min or filter_prix_max:
        if filter_prix_min.isdecimal() and filter_prix_max.isdecimal():
            if int(filter_prix_min) < int(filter_prix_max):
                session['filter_prix_min'] = filter_prix_min
                session['filter_prix_max'] = filter_prix_max
            else:
                flash(u'Le prix minimal doit etre inferieur au prix maximal')
        else:
            flash(u'min et max doivent être des numériques')

    if filter_types and filter_types != []:
        print("filter_types:", filter_types)
        if isinstance(filter_types, list):  # type (filter_types) = list :
            check_filter_type = True
            for number_type in filter_types:
                print('test', number_type)
            if not number_type.isdecimal():
                check_filter_type = False
            if check_filter_type:
                print(filter_types)
                session['filter_types'] = filter_types

    if filter_sexes and filter_sexes != []:
        print("filter_sexes:", filter_sexes)
        if isinstance(filter_sexes, list):  # type (filter_sexes) = list :
            check_filter_type = True
            for number_type in filter_sexes:
                print('test', number_type)
            if not number_type.isdecimal():
                check_filter_type = False
            if check_filter_type:
                print(filter_sexes)
                session['filter_sexes'] = filter_sexes

    if filter_tailles and filter_tailles != []:
        print("filter_tailles:", filter_tailles)
        if isinstance(filter_tailles, list):  # type (filter_tailles) = list :
            check_filter_type = True
            for number_type in filter_tailles:
                print('test', number_type)
            if not number_type.isdecimal():
                check_filter_type = False
            if check_filter_type:
                print(filter_tailles)
                session['filter_tailles'] = filter_tailles
    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))

@client_article.route('/client/filtre/suppr')
def client_article_filtre_suppr():
    session.pop('filter_word', None)
    session.pop('filter_prix_min', None)
    session.pop('filter_prix_max', None)
    session.pop('filter_types', None)
    session.pop('filter_sexes', None)
    session.pop('filter_tailles', None)
    return redirect('/client/article/show')