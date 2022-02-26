#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

admin_type_article = Blueprint('admin_type_article', __name__,
                        template_folder='templates')

@admin_type_article.route('/admin/other/show')
def show_type_article():
    # select :
    mycursor = get_db().cursor()
    select_sql = '''SELECT * FROM sexe'''
    mycursor.execute(select_sql)
    sexe = mycursor.fetchall()
    select_sql = '''SELECT * FROM type_vetement
    join  saison on saison.id_saison=type_vetement.id_saison'''
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
    select_sql = '''SELECT * FROM saison'''
    mycursor.execute(select_sql)
    saison = mycursor.fetchall()
    return render_template('admin/other/show_other.html', sexe=sexe, type=type, taille=taille, style=style, matiere=matiere, marque=marque,saison=saison)




@admin_type_article.route('/admin/other/admin/marque/add', methods=['POST'])
def add_marque():
    mycursor = get_db().cursor()
    libelle = request.form.get('libelle', '')
    tuple_insert = (libelle)
    requete='''INSERT INTO marque VALUES(NULL,%s)'''
    mycursor.execute(requete,tuple_insert)
    get_db().commit()
    return redirect('/admin/other/show')\

@admin_type_article.route('/admin/other/marque/delete/<int:id>', methods=['GET'])
def delete_marque(id):
    mycursor = get_db().cursor()
    tuple_insert = (id)
    requete='''DELETE FROM marque WHERE id_marque = %s'''
    mycursor.execute(requete,tuple_insert)
    get_db().commit()
    return redirect('/admin/other/show')

@admin_type_article.route('/admin/other/marque/edit/<int:id>', methods=['POST','GET'])
def edit_marque(id):
    mycursor = get_db().cursor()
    libelle = request.form.get('libelle')
    tuple_insert = (libelle,id)
    requete='''UPDATE marque SET libelle_marque=%s WHERE id_marque = %s'''
    mycursor.execute(requete,tuple_insert)
    get_db().commit()
    return redirect('/admin/other/show')




@admin_type_article.route('/admin/other/admin/style/add', methods=['POST'])
def add_style():
    mycursor = get_db().cursor()
    libelle = request.form.get('libelle', '')
    tuple_insert = (libelle)
    requete='''INSERT INTO style VALUES(NULL,%s)'''
    mycursor.execute(requete,tuple_insert)
    get_db().commit()
    return redirect('/admin/other/show')

@admin_type_article.route('/admin/other/style/delete/<int:id>', methods=['GET'])
def delete_style(id):
    mycursor = get_db().cursor()
    tuple_insert = (id)
    requete='''DELETE FROM style WHERE id_style = %s'''
    mycursor.execute(requete,tuple_insert)
    get_db().commit()
    return redirect('/admin/other/show')

@admin_type_article.route('/admin/other/style/edit/<int:id>', methods=['POST','GET'])
def edit_style(id):
    mycursor = get_db().cursor()
    libelle = request.form.get('libelle')
    tuple_insert = (libelle,id)
    requete='''UPDATE style SET libelle_style=%s WHERE id_style = %s'''
    mycursor.execute(requete,tuple_insert)
    get_db().commit()
    return redirect('/admin/other/show')




@admin_type_article.route('/admin/other/admin/matiere/add', methods=['POST'])
def add_matiere():
    mycursor = get_db().cursor()
    libelle = request.form.get('libelle', '')
    tuple_insert = (libelle)
    requete='''INSERT INTO matiere VALUES(NULL,%s)'''
    mycursor.execute(requete,tuple_insert)
    get_db().commit()
    return redirect('/admin/other/show')

@admin_type_article.route('/admin/other/matiere/delete/<int:id>', methods=['GET'])
def delete_matiere(id):
    mycursor = get_db().cursor()
    tuple_insert = (id)
    requete='''DELETE FROM matiere WHERE id_matiere = %s'''
    mycursor.execute(requete,tuple_insert)
    get_db().commit()
    return redirect('/admin/other/show')

@admin_type_article.route('/admin/other/matiere/edit/<int:id>', methods=['POST','GET'])
def edit_matiere(id):
    mycursor = get_db().cursor()
    libelle = request.form.get('libelle')
    tuple_insert = (libelle,id)
    requete='''UPDATE matiere SET libelle_matiere=%s WHERE id_matiere = %s'''
    mycursor.execute(requete,tuple_insert)
    get_db().commit()
    return redirect('/admin/other/show')




@admin_type_article.route('/admin/other/admin/taille/add', methods=['POST'])
def add_taille():
    mycursor = get_db().cursor()
    libelle = request.form.get('libelle', '')
    tuple_insert = (libelle)
    requete='''INSERT INTO taille VALUES(NULL,%s)'''
    mycursor.execute(requete,tuple_insert)
    get_db().commit()
    return redirect('/admin/other/show')

@admin_type_article.route('/admin/other/taille/delete/<int:id>', methods=['GET'])
def delete_taille(id):
    mycursor = get_db().cursor()
    tuple_insert = (id)
    requete='''DELETE FROM taille WHERE id_taille = %s'''
    mycursor.execute(requete,tuple_insert)
    get_db().commit()
    return redirect('/admin/other/show')

@admin_type_article.route('/admin/other/taille/edit/<int:id>', methods=['POST','GET'])
def edit_taille(id):
    mycursor = get_db().cursor()
    libelle = request.form.get('libelle')
    tuple_insert = (libelle,id)
    requete='''UPDATE taille SET libelle_taille=%s WHERE id_taille = %s'''
    mycursor.execute(requete,tuple_insert)
    get_db().commit()
    return redirect('/admin/other/show')




@admin_type_article.route('/admin/other/admin/sexe/add', methods=['POST'])
def add_sexe():
    mycursor = get_db().cursor()
    libelle = request.form.get('libelle', '')
    tuple_insert = (libelle)
    requete='''INSERT INTO sexe VALUES(NULL,%s)'''
    mycursor.execute(requete,tuple_insert)
    get_db().commit()
    return redirect('/admin/other/show')

@admin_type_article.route('/admin/other/sexe/delete/<int:id>', methods=['GET'])
def delete_sexe(id):
    mycursor = get_db().cursor()
    tuple_insert = (id)
    requete='''DELETE FROM sexe WHERE id_sexe = %s'''
    mycursor.execute(requete,tuple_insert)
    get_db().commit()
    return redirect('/admin/other/show')

@admin_type_article.route('/admin/other/sexe/edit/<int:id>', methods=['POST','GET'])
def edit_sexe(id):
    mycursor = get_db().cursor()
    libelle = request.form.get('libelle')
    tuple_insert = (libelle,id)
    requete='''UPDATE sexe SET libelle_sexe=%s WHERE id_sexe = %s'''
    mycursor.execute(requete,tuple_insert)
    get_db().commit()
    return redirect('/admin/other/show')




@admin_type_article.route('/admin/other/admin/type/add', methods=['POST'])
def add_type_vetement():
    mycursor = get_db().cursor()
    libelle = request.form.get('libelle', '')
    saison = request.form.get('saison', '')
    tuple_insert = (libelle,saison)
    requete='''INSERT INTO type_vetement VALUES(NULL,%s,%s)'''
    mycursor.execute(requete,tuple_insert)
    get_db().commit()
    return redirect('/admin/other/show')

@admin_type_article.route('/admin/other/type/delete/<int:id>', methods=['GET'])
def delete_type_vetement(id):
    mycursor = get_db().cursor()
    tuple_insert = (id)
    requete='''DELETE FROM type_vetement WHERE id_type_vetement = %s'''
    mycursor.execute(requete,tuple_insert)
    get_db().commit()
    return redirect('/admin/other/show')

@admin_type_article.route('/admin/other/type/edit/<int:id>', methods=['POST','GET'])
def edit_type_vetement(id):
    mycursor = get_db().cursor()
    libelle = request.form.get('libelle')
    tuple_insert = (libelle,id)
    requete='''UPDATE type_vetement SET libelle_type_vetement=%s WHERE id_type_vetement = %s'''
    mycursor.execute(requete,tuple_insert)
    get_db().commit()
    return redirect('/admin/other/show')










