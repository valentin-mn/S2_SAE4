#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

admin_commande = Blueprint('admin_commande', __name__,
                        template_folder='templates')

@admin_commande.route('/admin/commande/index')
def admin_index():
    return render_template('admin/layout_admin.html')


@admin_commande.route('/admin/commande/show', methods=['get','post'])
def admin_commande_show():
    mycursor = get_db().cursor()
    recuperation_commande_totale = '''SELECT * FROM commande c 
        join adresse a on c.id_adresse=a.id_adresse 
        join etat e on e.id_etat = c.id_etat 
        join users on users.id_users = c.id_users
        order by c.id_commande'''
    mycursor.execute(recuperation_commande_totale)
    commandes = mycursor.fetchall()
    recuperation_etat='''SELECT * from etat'''
    mycursor.execute(recuperation_etat)
    etats=mycursor.fetchall()
    return render_template('admin/commande/show.html', commandes=commandes,etats=etats)


@admin_commande.route('/admin/commande/show/details/<int:id_commande>&<int:id_users>', methods=['get','post'])
def client_commande_show_details(id_commande,id_users):
    mycursor = get_db().cursor()
    tuple_recup = (id_users,id_commande)
    recuperation_commande = '''SELECT * ,quantite*prix_vetement as somme_article  FROM commande c 
    join adresse a on c.id_adresse=a.id_adresse 
    join etat e on e.id_etat = c.id_etat 
    join ligne_commande lc on lc.id_commande = c.id_commande 
    join vetement v on v.id_vetement = lc.id_vetement 
    join propose p on p.id_vetement= lc.id_vetement 
    join marque m on m.id_marque=p.id_marque
    WHERE id_users =%s AND c.id_commande= %s order by c.id_commande '''
    mycursor.execute(recuperation_commande, tuple_recup)
    commande = mycursor.fetchall()

    # recuperation somme totale
    tuple_recup = (id_users,id_commande)
    recuperation_somme_totale = '''SELECT SUM(quantite*prix_vetement) as somme ,SUM(quantite) as quantite, SUM(quantite*prix_vetement)+SUM(quantite) as total FROM commande
    join ligne_commande lc on lc.id_commande=commande.id_commande 
    join vetement on lc.id_vetement=vetement.id_vetement 
    WHERE id_users = %s AND lc.id_commande = %s'''
    mycursor.execute(recuperation_somme_totale, tuple_recup)
    prix_total = mycursor.fetchone()

    articles_id = []
    articles_requete = commande
    articles_return = []
    i = 0
    for key in articles_requete:
        i += 1;
        print(articles_return)
        print(i)
        if (key['id_vetement'] not in articles_id):
            articles_id.append(key['id_vetement'])
            articles_return.append(key)
        else:
            articles_return[i - 2]['libelle_marque'] += ' x ' + key['libelle_marque']
    print("TADAMMM")
    print(articles_return)
    return render_template('admin/commande/show.html', commande=articles_return, prix_total=prix_total)


@admin_commande.route('/admin/commande/edit_etat/<int:id_commande>&<int:id_etat>', methods=['get','post'])
def admin_commande_valider(id_commande,id_etat):
    mycursor = get_db().cursor()
    tuple_update = (id_etat,id_commande)
    requete ='''UPDATE commande set id_etat = %s WHERE id_commande= %s'''
    mycursor.execute(requete,tuple_update)
    get_db().commit()

    return redirect('/admin/commande/show') 
