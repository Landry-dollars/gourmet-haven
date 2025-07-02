from flask import Flask, request, jsonify
import mysql.connector
from datetime import datetime
import json

app = Flask(__name__)

# Database configuration
db_config = {
    'host': 'localhost',
    'user': 'restaurant_admin',
    'password': 'securepassword123',
    'database': 'restaurant_db'
}

def get_db_connection():
    return mysql.connector.connect(**db_config)

@app.route('/api/reservations', methods=['POST'])
def create_reservation():
    data = request.get_json()
    
    required_fields = ['name', 'email', 'phone', 'date', 'time', 'guests', 'special_requests']
    if not all(field in data for field in required_fields):
        return jsonify({'success': False, 'message': 'Missing required fields'}), 400
    
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        query = """
        INSERT INTO reservations (name, email, phone, reservation_date, reservation_time, guests, special_requests, created_at)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """
        values = (
            data['name'],
            data['email'],
            data['phone'],
            data['date'],
            data['time'],
            data['guests'],
            data['special_requests'],
            datetime.now()
        )
        
        cursor.execute(query, values)
        conn.commit()
        
        return jsonify({
            'success': True,
            'message': 'Reservation created successfully',
            'reservation_id': cursor.lastrowid
        }), 201
        
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500
    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()

@app.route('/api/menu', methods=['GET'])
def get_menu():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        
        # Get categories
        cursor.execute("SELECT * FROM menu_categories ORDER BY display_order")
        categories = cursor.fetchall()
        
        menu = []
        
        for category in categories:
            cursor.execute("""
                SELECT id, name, description, price 
                FROM menu_items 
                WHERE category_id = %s 
                AND available = 1 
                ORDER BY display_order
            """, (category['id'],))
            
            items = cursor.fetchall()
            
            menu.append({
                'category': category['name'],
                'items': items
            })
        
        return jsonify({'success': True, 'menu': menu})
        
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)})
    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()

@app.route('/api/contact', methods=['POST'])
def handle_contact():
    data = request.get_json()
    
    required_fields = ['name', 'email', 'subject', 'message']
    if not all(field in data for field in required_fields):
        return jsonify({'success': False, 'message': 'Missing required fields'}), 400
    
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        query = """
        INSERT INTO contact_messages (name, email, subject, message, created_at)
        VALUES (%s, %s, %s, %s, %s)
        """
        values = (
            data['name'],
            data['email'],
            data['subject'],
            data['message'],
            datetime.now()
        )
        
        cursor.execute(query, values)
        conn.commit()
        
        return jsonify({
            'success': True,
            'message': 'Your message has been sent successfully'
        }), 201
        
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500
    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()

if __name__ == '__main__':
    app.run(debug=True, port=5000)
