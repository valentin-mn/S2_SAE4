#! /usr/bin/python
# -*- coding:utf-8 -*-
import os
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g
from werkzeug.utils import secure_filename
from connexion_db import get_db

admin_article = Blueprint('admin_article', __name__,
                        template_folder='templates')

@admin_article.route('/admin/article/show')
def show_article():
    mycursor = get_db().cursor()

    recuperation_article = '''SELECT DISTINCT vetement.id_vetement,libelle_vetement,libelle_marque,prix_vetement FROM vetement
    left join type_vetement on type_vetement.id_type_vetement=vetement.id_type_vetement
    left join propose p on p.id_vetement= vetement.id_vetement
    left join marque m on m.id_marque=p.id_marque
    right join est_dispo on est_dispo.id_vetement=vetement.id_vetement'''

    # gestion des filtres
    list_param = []
    condition_and = ""
    if "filter_word" in session or "filter_prix_min" in session or "filter_prix_max" in session or "filter_types" in session  or "filter_tailles" in session or "filter_sexes" in session:
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


    articles_id=[]
    articles_requete=articles
    articles_return=[]
    i=0
    for key in articles_requete:

        if (key['id_vetement'] not in articles_id):
            articles_id.append(key['id_vetement'])
            articles_return.append(key)
            i += 1;
        else:
            articles_return[i-1]['libelle_marque'] += ' x ' + key['libelle_marque']

    #necessaire au filtre
    recuperation_type_article = '''SELECT * FROM type_vetement order by libelle_type_vetement '''
    mycursor.execute(recuperation_type_article)
    types_articles = mycursor.fetchall()
    recuperation_sexe = '''SELECT * FROM sexe '''
    mycursor.execute(recuperation_sexe)
    sexes = mycursor.fetchall()
    recuperation_tailles = '''SELECT * FROM taille'''
    mycursor.execute(recuperation_tailles)
    tailles = mycursor.fetchall()

    return render_template('admin/article/show_article.html', articles=articles_return,itemsFiltreType=types_articles, sexes = sexes, tailles=tailles)

@admin_article.route('/admin/article/add', methods=['GET'])
def add_article():
    mycursor = get_db().cursor()
    select_sql='''SELECT * FROM sexe'''
    mycursor.execute(select_sql)
    sexe=mycursor.fetchall()
    select_sql = '''SELECT * FROM type_vetement'''
    mycursor.execute(select_sql)
    type = mycursor.fetchall()
    select_sql = '''SELECT * FROM taille'''
    mycursor.execute(select_sql)
    taille = mycursor.fetchall()
    select_sql = '''SELECT * FROM style'''
    mycursor.execute(select_sql)
    style = mycursor.fetchall()
    select_sql = '''SELECT * FROM matiere'''
    mycursor.execute(select_sql)
    matiere = mycursor.fetchall()
    select_sql = '''SELECT * FROM marque'''
    mycursor.execute(select_sql)
    marque = mycursor.fetchall()
    return render_template('admin/article/add_article.html', sexe=sexe,type=type,taille=taille,style=style,matiere=matiere,marque=marque)





@admin_article.route('/admin/article/details/<int:id>', methods=['GET'])
def admin_article_details(id):
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
    LIMIT 0,4'''
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
            i += 1;
            articles_id.append(key['id_vetement'])
            articles_return.append(key)
        else:
            articles_return[i - 1]['libelle_marque'] += ' x ' + key['libelle_marque']


    return render_template('admin/article/single_product.html',marques=marques,matieres=matieres,stat_comment = stat_comment, article=article, commentaires=commentaires, proposed=articles_return, id=id,tailles=tailles)

@admin_article.route('/admin/article/add', methods=['POST'])
def valid_add_article():
    mycursor = get_db().cursor()
    nom = request.form.get('nom', '')
    prix = request.form.get('prix', '')
    sexe = request.form.get('sexe','')
    type = request.form.get('type', '')
    nb_taille = request.form.get('nb_taille', '')
    tuple_insert=(prix,nom,sexe,type)
    requete_insert='''INSERT INTO vetement VALUES(NULL,%s,%s,%s,%s)'''
    mycursor.execute(requete_insert,tuple_insert)
    get_db().commit()


    recup_vetement = '''SELECT * FROM vetement ORDER BY id_vetement DESC LIMIT 1'''
    mycursor.execute(recup_vetement)
    result = mycursor.fetchone()
    id = result["id_vetement"]
    tailles = 'Aucune'
    if (int(nb_taille) > 0):
        tailles = ''
        for i in range(0,int(nb_taille)):
            taille=request.form.get('taille_'+str(i), '')
            quantite=request.form.get('quantite_'+str(i), '')
            tailles += taille + " (" + quantite +"),"
            tuple_insert=(id,taille,quantite)
            insert_taille='''INSERT INTO est_dispo VALUES(%s,%s,%s)'''
            mycursor.execute(insert_taille,tuple_insert)
        get_db().commit()

    nb_style = request.form.get('nb_style', '')
    styles='Aucun'
    if (int(nb_style)>0):
        styles = ''
        for i in range(0,int(nb_style)):
            style=request.form.get('style_'+str(i), '')
            styles+= style +", "
            tuple_insert=(id,style)
            insert_style='''INSERT INTO appartient_a VALUES(%s,%s)'''
            mycursor.execute(insert_style,tuple_insert)
        get_db().commit()


    nb_matiere = request.form.get('nb_matiere', '')
    matieres='Aucune'
    if (int(nb_matiere) > 0):
        matieres = ''
        for i in range(0,int(nb_matiere)):
            matiere=request.form.get('matiere_'+str(i), '')
            matieres+= matiere +", "
            tuple_insert=(id,matiere)
            insert_matiere='''INSERT INTO est_en VALUES(%s,%s)'''
            mycursor.execute(insert_matiere,tuple_insert)
        get_db().commit()

    nb_marque = request.form.get('nb_marque', '')
    marques='Aucune'
    if (int(nb_marque) > 0):
        marques = ''
        for i in range(0, int(nb_marque)):
            marque = request.form.get('marque_' + str(i), '')
            marques+= marque +", "
            tuple_insert = (id, marque)
            insert_marque = '''INSERT INTO propose VALUES(%s,%s)'''
            mycursor.execute(insert_marque, tuple_insert)

    else :
        tuple_insert = (id, 4)
        insert_marque = '''INSERT INTO propose VALUES(%s,%s)'''
        mycursor.execute(insert_marque, tuple_insert)
    get_db().commit()



    image='no'
    UPLOAD_FOLDER = 'static/assets/images/'
    if 'img' not in request.files:
        flash('Fichier absent')
        return redirect(request.url)
    file = request.files['img']
    if file.filename == '':
        flash('Aucun fichier selectionné')
        return redirect(request.url)
    if file:
        file.save(os.path.join(UPLOAD_FOLDER, "produit"+str(id)+".png"))
        image = 'yes'


    message = u'article ajouté , nom:'+nom + ', type_article:' + type + ', prix:' + prix + ', taille(s):'+  tailles + ' styles :' + styles + ' marque(s) :' + marques + ' matière(s) : ' + matieres + ' image : ' + image
    flash(message)
    print(message)
    return redirect(url_for('admin_article.show_article'))

@admin_article.route('/admin/article/delete/<int:id>', methods=['GET'])
def delete_article(id):
    mycursor = get_db().cursor()
    tuple_delete=(str(id));
    delete_article='''DELETE FROM vetement WHERE id_vetement = %s'''
    delete_appartient_a='''DELETE FROM appartient_a WHERE id_vetement = %s'''
    delete_est_dispo='''DELETE FROM est_dispo WHERE id_vetement = %s'''
    delete_est_en='''DELETE FROM est_en WHERE id_vetement = %s'''
    delete_propose='''DELETE FROM propose WHERE id_vetement = %s'''
    delete_panier='''DELETE FROM panier WHERE id_vetement = %s'''
    delete_ligne_commande='''DELETE FROM ligne_commande WHERE id_vetement = %s'''
    delete_commentaires='''DELETE FROM commentaires WHERE id_vetement = %s'''
    mycursor.execute(delete_appartient_a,tuple_delete)
    mycursor.execute(delete_est_dispo,tuple_delete)
    mycursor.execute(delete_est_en,tuple_delete)
    mycursor.execute(delete_propose,tuple_delete)
    mycursor.execute(delete_panier,tuple_delete)
    mycursor.execute(delete_ligne_commande,tuple_delete)
    mycursor.execute(delete_commentaires, tuple_delete)
    mycursor.execute(delete_article, tuple_delete)

    get_db().commit()


    print("un article supprimé, id :", str(id))
    flash(u'un article supprimé, id : ' + str(id))
    return redirect(url_for('admin_article.show_article'))

@admin_article.route('/admin/article/edit/<int:id>', methods=['GET'])
def edit_article(id):
#select :
    mycursor = get_db().cursor()
    select_sql='''SELECT * FROM sexe'''
    mycursor.execute(select_sql)
    sexe=mycursor.fetchall()
    select_sql = '''SELECT * FROM type_vetement'''
    mycursor.execute(select_sql)
    type = mycursor.fetchall()
    select_sql = '''SELECT * FROM taille'''
    mycursor.execute(select_sql)
    taille = mycursor.fetchall()
    select_sql = '''SELECT * FROM style'''
    mycursor.execute(select_sql)
    style = mycursor.fetchall()
    select_sql = '''SELECT * FROM matiere'''
    mycursor.execute(select_sql)
    matiere = mycursor.fetchall()
    select_sql = '''SELECT * FROM marque'''
    mycursor.execute(select_sql)
    marque = mycursor.fetchall()
    tuple_select = (id);
    select_article = '''SELECT * FROM vetement where id_vetement = %s'''
    mycursor.execute(select_article, tuple_select)
    article = mycursor.fetchone()


    select_sql = '''SELECT * FROM est_dispo join taille on taille.id_taille=est_dispo.id_taille where id_vetement = %s'''
    mycursor.execute(select_sql,tuple_select)
    taille_select = mycursor.fetchall()
    select_sql = '''SELECT * FROM appartient_a join style on style.id_style=appartient_a.id_style where id_vetement = %s'''
    mycursor.execute(select_sql,tuple_select)
    style_select = mycursor.fetchall()
    select_sql = '''SELECT * FROM est_en join matiere on matiere.id_matiere=est_en.id_matiere where id_vetement = %s'''
    mycursor.execute(select_sql,tuple_select)
    matiere_select = mycursor.fetchall()
    select_sql = '''SELECT * FROM propose join marque on marque.id_marque=propose.id_marque where id_vetement = %s'''
    mycursor.execute(select_sql,tuple_select)
    marque_select = mycursor.fetchall()




    types_articles = None
    return render_template('admin/article/edit_article.html',marque_select=marque_select,matiere_select=matiere_select,style_select=style_select, article=article, sexe=sexe,type=type,taille=taille,style=style,matiere=matiere,marque=marque,taille_select=taille_select)

@admin_article.route('/admin/article/edit', methods=['POST'])
def valid_edit_article():
    print(request.values)
    mycursor = get_db().cursor()
    nom = request.form.get('nom', '')
    id = request.form.get('id_article', '')
    prix = request.form.get('prix', '')
    sexe = request.form.get('sexe', '')
    type = request.form.get('type', '')
    tuple_insert = (prix, nom, sexe, type,id)
    requete_insert = '''UPDATE vetement SET prix_vetement=%s ,libelle_vetement=%s, id_sexe=%s, id_type_vetement=%s WHERE id_vetement= %s '''
    mycursor.execute(requete_insert, tuple_insert)
    get_db().commit()

    tuple_delete=(id)
    delete_appartient_a = '''DELETE FROM appartient_a WHERE id_vetement = %s'''
    delete_est_dispo = '''DELETE FROM est_dispo WHERE id_vetement = %s'''
    delete_est_en = '''DELETE FROM est_en WHERE id_vetement = %s'''
    delete_propose = '''DELETE FROM propose WHERE id_vetement = %s'''
    mycursor.execute(delete_appartient_a, tuple_delete)
    mycursor.execute(delete_est_dispo, tuple_delete)
    mycursor.execute(delete_est_en, tuple_delete)
    mycursor.execute(delete_propose, tuple_delete)
    nb_taille = request.form.get('nb_taille', '')
    if (int(nb_taille) > 0):
        tailles = ''
        for i in range(0,int(nb_taille)):
            taille=request.form.get('taille_'+str(i), '')
            quantite=request.form.get('quantite_'+str(i), '')
            tailles += taille + " (" + quantite +"),"
            tuple_insert=(id,taille,quantite)
            insert_taille='''INSERT INTO est_dispo VALUES(%s,%s,%s)'''
            mycursor.execute(insert_taille,tuple_insert)
        get_db().commit()


    nb_style = request.form.get('nb_style', '')
    styles='Aucun'
    if (int(nb_style)>0):
        styles = ''
        for i in range(0,int(nb_style)):
            style=request.form.get('style_'+str(i), '')
            styles+= style +", "
            tuple_insert=(id,style)
            insert_style='''INSERT INTO appartient_a VALUES(%s,%s)'''
            mycursor.execute(insert_style,tuple_insert)
        get_db().commit()


    nb_matiere = request.form.get('nb_matiere', '')
    matieres='Aucune'
    if (int(nb_matiere) > 0):
        matieres = ''
        for i in range(0,int(nb_matiere)):
            matiere=request.form.get('matiere_'+str(i), '')
            matieres+= matiere +", "
            tuple_insert=(id,matiere)
            insert_matiere='''INSERT INTO est_en VALUES(%s,%s)'''
            mycursor.execute(insert_matiere,tuple_insert)
        get_db().commit()

    nb_marque = request.form.get('nb_marque', '')
    marques='Aucune'
    if (int(nb_marque) > 0):
        marques = ''
        for i in range(0, int(nb_marque)):
            marque = request.form.get('marque_' + str(i), '')
            marques+= marque +", "
            tuple_insert = (id, marque)
            insert_marque = '''INSERT INTO propose VALUES(%s,%s)'''
            mycursor.execute(insert_marque, tuple_insert)
    get_db().commit()

    message='Non'
    flash(message)
    return redirect(url_for('admin_article.show_article'))


@admin_article.route('/admin/comment/delete/<int:id_comm>&<int:article_id>', methods=['GET'])
def admin_comment_detete(id_comm,article_id):
    mycursor = get_db().cursor()
    tuple_delete = (id_comm)
    requete_delete = '''DELETE FROM commentaires WHERE id_commentaires=%s'''
    mycursor.execute(requete_delete, tuple_delete)
    get_db().commit()
    message='Le commentaire n°' + str(id_comm) + ' à été supprimé'
    flash(message)
    return redirect('/admin/article/details/'+str(article_id))\

@admin_article.route('/admin/article/filtre', methods=['POST'])
def admin_article_filtre():
    # SQL
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
                print (filter_types)
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

    return redirect('/admin/article/show')

@admin_article.route('/admin/filtre/suppr')
def admin_article_filtre_suppr():
    session.pop('filter_word', None)
    session.pop('filter_prix_min', None)
    session.pop('filter_prix_max', None)
    session.pop('filter_types', None)
    session.pop('filter_sexes', None)
    session.pop('filter_tailles', None)
    return redirect('/admin/article/show')