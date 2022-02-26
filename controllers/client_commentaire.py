#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

client_commentaire = Blueprint('client_commentaire', __name__,
                        template_folder='templates')

@client_commentaire.route('/client/comment/add', methods=['POST'])
def client_comment_add():
    mycursor = get_db().cursor()
    id_vetement=request.form.get('id_article', '')
    comment = request.form.get('comment','')
    note = request.form.get('note','')
    tuple_insert=(comment,note,id_vetement,session['user_id'])
    requete_insert = '''INSERT INTO commentaires VALUES(NULL,DATE(NOW()),%s,%s,%s,%s)'''
    mycursor.execute(requete_insert,tuple_insert)
    get_db().commit()
    return redirect('/client/article/details/'+id_vetement)
    #return redirect(url_for('client_article_details', id=int(article_id)))

@client_commentaire.route('/client/comment/delete/<int:id_comm>&<int:article_id>', methods=['GET'])
def client_comment_detete(id_comm,article_id):
    mycursor = get_db().cursor()
    tuple_select = (id_comm)
    requete_select = '''SELECT * FROM commentaires WHERE id_commentaires=%s'''
    mycursor.execute(requete_select,tuple_select)
    commentaire = mycursor.fetchone()
    if (commentaire['id_users'] == session['user_id']):
        tuple_delete = (id_comm)
        requete_delete = '''DELETE FROM commentaires WHERE id_commentaires=%s'''
        mycursor.execute(requete_delete, tuple_delete)
        get_db().commit()
        message='Le commentaire n°' + str(id_comm) + ' à été supprimé'
    else :
        message="Vous n'avez pas posté ce commentaire, vous ne pouvez donc pas le supprimer"



    flash(message)
    return redirect('/client/article/details/'+str(article_id))
    #return redirect(url_for('client_article_details', id=int(article_id)))