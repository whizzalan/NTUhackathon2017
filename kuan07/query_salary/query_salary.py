# -*- coding: utf-8 -*-
import sqlite3
from flask import Flask, request, Response, jsonify

app = Flask(__name__)


@app.route('/salary', methods=['POST'])
def salary_query():
    if request.method == "POST":
        try:
            input = request.get_json()  # get JSON in the request
            input = {k: "%" + v + "%" for k, v in input.items() if v}
            where_sql = " and ".join(["{0[0]} LIKE '{0[1]}' ".format(value) for value in input.items()])
            group_sql = ",".join(input.keys())

            conn = sqlite3.connect('salary_db')
            cursor = conn.cursor()

            sql_command = "SELECT AVG(mean) FROM salary WHERE {0} GROUP BY {1} ;".format(where_sql, group_sql)
            cursor.execute(sql_command)
            values = cursor.fetchall()

            cursor.close()
            conn.close()

            return jsonify({'value':int(values[0][0])})
        except:
            return jsonify({'value': 0})
    else:
        return jsonify({'value':0})


if __name__ == '__main__':
    app.run(debug=True)
