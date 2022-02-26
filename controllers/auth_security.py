#! /usr/bin/python
# -*- coding:utf-8 -*-

from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g
from werkzeug.security import generate_password_hash, check_password_hash

from connexion_db import get_db

auth_security = Blueprint('auth_security', __name__,
                        template_folder='templates')


@auth_security.route('/login')
def auth_login():
    return render_template('auth/login.html')


@auth_security.route('/login', methods=['POST'])
def auth_login_post():
    mycursor = get_db().cursor()
    username = request.form.get('username')
    password = request.form.get('password')
    tuple_select = (username)
    sql = '''SELECT * FROM users WHERE  username_users=%s'''
    retour = mycursor.execute(sql, (username))
    user = mycursor.fetchone()
    print(user)
    if user:
        mdp_ok = check_password_hash(user['password_users'], password)
        if not mdp_ok:
            flash(u'Vérifier votre mot de passe et essayer encore.')
            return redirect('/login')
        else:
            session['username'] = user['username_users']
            session['role'] = user['role_users']
            session['user_id'] = user['id_users']
            print(user['username_users'], user['role_users'])
            if user['role_users'] == 'ROLE_admin':
                return redirect('/')
            else:
                return redirect('/')
    else:
        flash(u'Vérifier votre login et essayer encore.')
        return redirect('/login')


@auth_security.route('/signup', methods=['POST'])
def auth_signup_post():
    mycursor = get_db().cursor()
    username = request.form.get('username')
    nom = request.form.get('nom')
    prenom = request.form.get('prenom')
    numtel = request.form.get('numtel')
    email = request.form.get('email')
    password = request.form.get('password')

    tuple_select = (username,email)
    sql = '''SELECT * FROM users WHERE username_users = %s OR email_users = %s'''
    retour = mycursor.execute(sql, tuple_select)
    user = mycursor.fetchone()
    if user:
        flash(u'votre adresse <strong>Email</strong> ou <strong>Username</strong> existe déjà')
        return redirect('/login')

    # ajouter un nouveau user
    password = generate_password_hash(password, method='sha256')
    tuple_insert = (username, nom, prenom,numtel,email,password, 'ROLE_client')
    print(tuple_insert)
    print(tuple)
    sql = '''INSERT INTO users VALUES (NULL,%s  ,%s,%s,%s,%s,%s,%s)'''
    mycursor.execute(sql, tuple_insert)
    get_db().commit()                    # position de cette ligne discutatble !
    sql = '''SELECT * FROM users WHERE id_users=(SELECT max(id_users) FROM users)'''
    mycursor.execute(sql)
    info_last_id = mycursor.fetchone()
    user_id = info_last_id['id_users']
    print('last_insert_id', user_id)
    get_db().commit()
    session.pop('username', None)
    session.pop('role', None)
    session.pop('user_id', None)
    session['username'] = username
    session['role'] = 'ROLE_client'
    session['user_id'] = user_id
    return redirect('/')
    #return redirect(url_for('client_index'))


@auth_security.route('/logout')
def auth_logout():
    session.pop('username', None)
    session.pop('role', None)
    session.pop('user_id', None)
    session.pop('filter_word', None)
    session.pop('filter_prix_min', None)
    session.pop('filter_prix_max', None)
    session.pop('filter_types', None)
    session.pop('filter_sexes', None)
    session.pop('filter_tailles', None)
    return redirect('/')
    #return redirect(url_for('main_index'))

@auth_security.route('/forget-password', methods=['GET'])
def forget_password():
    return render_template('auth/forget_password.html')

