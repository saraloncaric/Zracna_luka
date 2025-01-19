from flask import Flask, request, jsonify, render_template, redirect, url_for
from flask_mysqldb import MySQL

app = Flask(__name__)

app.config['JSON_AS_ASCII'] = False
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'user1'
app.config['MYSQL_PASSWORD'] = 'user1'
app.config['MYSQL_DB'] = 'zracnaluka'


mysql = MySQL(app)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/opcenito')
def opcenito():
    return render_template('opcenito.html')


@app.route('/avionske_kompanije', methods=['GET'])
def get_avionske_kompanije():
    curr = mysql.connection.cursor()
    curr.execute("SELECT * FROM avionske_kompanije")
    kompanije = curr.fetchall()
    print(kompanije)  
    curr.close()
    return render_template('avionske_kompanije.html', kompanije=kompanije)

@app.route('/avionske_kompanije', methods=['POST'])
def add_avionska_kompanija():
    data = request.get_json()
    curr = mysql.connection.cursor()
    curr.execute(
        "INSERT INTO avionske_kompanije (naziv, drzava) VALUES (%s, %s, %s)",
        (data['naziv'], data['drzava'])
    )
    mysql.connection.commit()
    curr.close()
    return jsonify({"message": "Avionska kompanija uspješno dodana."}), 201

@app.route('/avionske_kompanije/<int:id>', methods=['PUT'])
def update_avionska_kompanija(id):
    data = request.get_json()
    curr = mysql.connection.cursor()
    curr.execute(
        """
        UPDATE avionske_kompanije
        SET naziv = %s, drzava = %s
        WHERE id = %s
        """,
        (data['naziv'], data['drzava'], id)
    )
    mysql.connection.commit()
    curr.close()
    return jsonify({"message": "Avionska kompanija uspješno ažurirana."}), 200

@app.route('/avionske_kompanije/<int:id>', methods=['DELETE'])
def delete_avionska_kompanija(id):
    curr = mysql.connection.cursor()
    curr.execute("DELETE FROM avionske_kompanije WHERE id = %s", (id,))
    mysql.connection.commit()
    curr.close()
    return jsonify({"message": "Avionska kompanija uspješno obrisana."}), 200


@app.route('/avioni', methods=['GET'])
def get_avioni():
    curr = mysql.connection.cursor()
    curr.execute("SELECT * FROM avioni")
    avioni = curr.fetchall()
    curr.close()
    return render_template('avioni.html', avioni=avioni)

@app.route('/add_avioni', methods=['GET','POST'])
def add_avioni():
    if request.method == 'POST':
        model = request.form['model']
        kapacitet = request.form['kapacitet']
        godina_proizvodnje=request.form['godina_proizvodnje']
        id_kompanije = request.form['id_kompanije']

        curr = mysql.connection.cursor()
        curr.execute(
            "INSERT INTO avioni (model, kapacitet, godina_proizvodnje, id_kompanije)   VALUES (%s, %s, %s, %s)",
            (model , kapacitet, godina_proizvodnje , id_kompanije)
        )
        mysql.connection.commit()
        curr.close()

        return redirect(url_for('get_avioni'))
    return render_template('add_avioni.html')

@app.route('/avioni/<int:id>', methods=['PUT'])
def update_avioin(id):
    data = request.get_json()
    curr = mysql.connection.cursor()
    curr.execute(
        """
        UPDATE avioni
        SET model = %s, kapacitet = %s, godina_proizvodnje = %s, id_kompanije = %s
        WHERE id = %s
        """,
        (
            data['model'],
            data['kapacitet'],
            data['godina_proizvodnje'],
            data['id_kompanije']
        )
    )
    mysql.connection.commit()
    curr.close()
    return jsonify({"message": "Avion uspješno dodan."}), 200

@app.route('/avioni/<int:id>', methods=['DELETE'])
def delete_avion(id):
    curr = mysql.connection.cursor()
    curr.execute("DELETE FROM avioni WHERE id = %s", (id,))
    mysql.connection.commit()
    curr.close()
    return jsonify({"message": "Avion uspješno obrisan."}), 200


@app.route('/letovi', methods=['GET'])
def letovi():
    curr = mysql.connection.cursor()
    curr.execute("SELECT * FROM letovi")
    letovi = curr.fetchall()
    curr.close()
    return render_template('letovi.html', letovi=letovi)

@app.route('/add_let', methods=['GET', 'POST'])
def add_let():
    if request.method == 'POST':
        broj_leta = request.form['broj_leta']
        vrijeme_polaska = request.form['vrijeme_polaska']
        vrijeme_dolaska=request.form['vrijeme_dolaska']
        trenutni_status=request.form['trenutni_status']
        id_avion = request.form['id_avion']
        id_gate = request.form['id_gate']
        id_pista = request.form['id_pista']

        curr = mysql.connection.cursor()

        curr.execute(
            "INSERT INTO letovi (broj_leta, vrijeme_polaska, vrijeme_dolaska, trenutni_status, id_avion, id_gate, id_pista)   VALUES (%s, %s, %s, %s, %s, %s, %s)",
            (broj_leta, vrijeme_polaska, vrijeme_dolaska, trenutni_status, id_avion, id_gate, id_pista)
        )
        mysql.connection.commit()
        curr.close()

        return redirect(url_for('letovi'))
    return render_template('add_let.html')

@app.route('/letovi/<int:id>', methods=['PUT'])
def update_let(id):
    data = request.get_json()
    curr = mysql.connection.cursor()
    curr.execute(
        """
        UPDATE letovi
        SET broj_leta = %s, vrijeme_polaska = %s, vrijeme_dolaska = %s, id_avion = %s, id_gate = %s, id_pista = %s
        WHERE id = %s
        """,
        (
            data['broj_leta'],
            data['vrijeme_polaska'],
            data['vrijeme_dolaska'],
            data['id_avion'], 
            data['id_gate'],
            data['id_pista']
        )
    )
    mysql.connection.commit()
    curr.close()
    return jsonify({"message": "Let uspješno dodan."}), 200

@app.route('/letovi/<int:id>', methods=['DELETE'])
def delete_let(id):
    curr = mysql.connection.cursor()
    curr.execute("DELETE FROM letovi WHERE id = %s", (id,))
    mysql.connection.commit()
    curr.close()
    return jsonify({"message": "Let uspješno obrisan."}), 200


@app.route('/zaposlenici', methods=['GET'])
def show_zaposlenik():
    curr = mysql.connection.cursor()
    curr.execute("SELECT * FROM zaposlenici")
    zaposlenici_show = curr.fetchall()  
    curr.close()
    return render_template('zaposlenici.html', zaposlenici=zaposlenici_show)

@app.route('/add_zaposlenik_form', methods=['GET'])
def add_zaposlenik_form():
    return render_template('add_zaposlenik.html')

@app.route('/zaposlenici', methods=['GET', 'POST'])
def zaposlenici():
    return "Lista zaposlenika"

@app.route('/add_zaposlenik', methods=['GET','POST'])
def add_zaposlenik():
    if request.method == 'POST':
        ime = request.form['ime']
        prezime = request.form['prezime']
        placa = request.form['placa']
        pozicija = request.form['pozicija']
        smjena = request.form['smjena']
        id_zracna_luka = request.form['id_zracna_luka']

        curr = mysql.connection.cursor()
        curr.execute(
            "INSERT INTO zaposlenici (ime, prezime, placa, pozicija, smjena, id_zracna_luka) VALUES (%s, %s, %s, %s, %s, %s)",
            (ime, prezime, placa, pozicija, smjena, id_zracna_luka)
        )
        mysql.connection.commit()
        curr.close()

        return redirect(url_for('zaposlenici'))
    return render_template('add_zaposlenik.html', message="Zaposlenik uspješno dodan!")

@app.route('/zaposlenik/<int:id>', methods=['PUT'])
def update_zaposlenik(id):
    data = request.get_json()
    curr = mysql.connection.cursor()
    curr.execute(
        """
        UPDATE zaposlenik
        SET ime = %s, prezime = %s, placa = %s, pozicija = %s, smjena = %s, id_zracna_luka = %s
        WHERE id = %s
        """,
        (
            data['ime'],
            data['prezime'],
            data['placa'],
            data['pozicija'],
            data['smjena'], 
            data['id_zracna_luka']
        )
    )
    mysql.connection.commit()
    curr.close()
    return jsonify({"message": "Zaposlenik uspješno dodan."}), 200


@app.route('/statistika', methods=['GET', 'POST'])
def statistika():
    if request.method == 'POST':
        start_date = request.form['start_date']
        end_date = request.form['end_date']

        curr = mysql.connection.cursor()
        query = """
            SELECT COUNT(*) FROM karte k
            JOIN putnici p ON k.id_putnik = p.id
            JOIN letovi l ON k.id_let = l.id
            WHERE DATE(l.vrijeme_dolaska) BETWEEN %s AND %s
        """
        curr.execute(query, (start_date, end_date))  
        broj_putnika = curr.fetchone()[0]
        curr.close()

        return render_template('statistika.html', 
                               start_date=start_date, 
                               end_date=end_date, 
                               broj_putnika=broj_putnika)
    
    return render_template('statistika.html', broj_putnika=None)


@app.route('/parkiraliste', methods=['GET'])
def show_parkiraliste():
    curr = mysql.connection.cursor()
    curr.execute("SELECT * FROM parkiranje")
    parkiraliste_show = curr.fetchall()  
    curr.close()
    return render_template('parkiraliste.html', parkiraliste=parkiraliste_show)


app.secret_key = 'your_secret_key'
temporary_data = []

@app.route('/rezervacija', methods=['GET', 'POST'])
def rezervacija():
    success = False
    odabrani_let = None 
    letovi = [
        {'id': 1, 'broj_leta': '1001', 'vrijeme_polaska': '2024-12-30 08:00:00', 'vrijeme_dolaska': '2024-12-30 10:30:00', 'status': 'Zakazan'},
        {'id': 2, 'broj_leta': '1002', 'vrijeme_polaska': '2024-12-30 09:00:00', 'vrijeme_dolaska': '2024-12-30 11:00:00', 'status': 'Zakazan'},
        {'id': 3, 'broj_leta': '1003', 'vrijeme_polaska': '2024-12-30 07:30:00', 'vrijeme_dolaska': '2024-12-30 11:00:00', 'status': 'Odgođen'},
        {'id': 4, 'broj_leta': '1004', 'vrijeme_polaska': '2024-12-30 10:00:00', 'vrijeme_dolaska': '2024-12-30 12:30:00', 'status': 'Zakazan'},
        {'id': 5, 'broj_leta': '1007', 'vrijeme_polaska': '2024-12-30 13:00:00', 'vrijeme_dolaska': '2024-12-30 15:00:00', 'status': 'Zakazan'}
    ]
    
    if request.method == 'POST':
        ime_prezime = request.form['ime_prezime']
        email = request.form['email']
        let_id = int(request.form['odabrani_let'])
        
        temporary_data.append({
            'ime_prezime': ime_prezime,
            'email': email,
            'let_id': let_id
        })

        for let in letovi:
            if let['id'] == let_id:
                odabrani_let = let  
        
        success = True  

    return render_template('rezervacija.html', letovi=letovi, success=success, odabrani_let=odabrani_let)


if __name__ == '__main__':
    app.run(debug=True, port=5000)