#! /usr/bin/python
# -*- coding:utf-8 -*-

from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g
from flask import Blueprint
import os
from werkzeug.utils import secure_filename
from controllers.auth_security import *

from controllers.client_article import *
from controllers.client_panier import *
from controllers.client_commande import *
from controllers.client_commentaire import *

from controllers.admin_article import *
from controllers.admin_commande import *
from controllers.admin_panier import *
from controllers.admin_other import *
from controllers.admin_dataviz_article import *

app = Flask(__name__)
app.secret_key = 'une cle(token) : grain de sel(any random string)'




@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()


@app.route('/')
def show_accueil():
    mycursor = get_db().cursor()
    recuperation_article = '''SELECT * FROM vetement  join type_vetement on type_vetement.id_type_vetement=vetement.id_type_vetement join propose p on p.id_vetement= vetement.id_vetement join marque m on m.id_marque=p.id_marque order by vetement.id_vetement DESC LIMIT 8;'''
    mycursor.execute(recuperation_article)
    articles = mycursor.fetchall()
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
    return render_template('layout.html', articles=articles_return)




##################
# Authentification
##################

# Middleware de sécurité

@app.before_request
def before_request():
     if request.path.startswith('/admin') or request.path.startswith('/client'):
        if 'role' not in session:
            return redirect('/login')
            #return redirect(url_for('auth_login'))
        else:
            if (request.path.startswith('/client') and session['role'] != 'ROLE_client') or (request.path.startswith('/admin') and session['role'] != 'ROLE_admin'):
                print('pb de route : ', session['role'], request.path.title(), ' => deconnexion')
                session.pop('username', None)
                session.pop('role', None)
                return redirect('/login')
                #return redirect(url_for('auth_login'))


app.register_blueprint(auth_security)

app.register_blueprint(client_article)
app.register_blueprint(client_commande)
app.register_blueprint(client_commentaire)
app.register_blueprint(client_panier)

app.register_blueprint(admin_article)
app.register_blueprint(admin_commande)
app.register_blueprint(admin_panier)
app.register_blueprint(admin_type_article)
app.register_blueprint(admin_dataviz_article)


if __name__ == '__main__':
    app.run()

