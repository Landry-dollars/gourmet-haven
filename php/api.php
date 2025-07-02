<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST");
header("Access-Control-Allow-Headers: Content-Type");

require_once 'db_config.php';

$action = $_GET['action'] ?? '';

$response = [
    'success' => false,
    'message' => 'Invalid action'
];

try {
    $pdo = new PDO(
        "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME,
        DB_USER,
        DB_PASSWORD
    );
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    switch ($action) {
        case 'get_menu':
            $stmt = $pdo->query("
                SELECT c.name AS category, i.name, i.description, i.price 
                FROM menu_items i
                JOIN menu_categories c ON i.category_id = c.id
                WHERE i.available = 1
                ORDER BY c.display_order, i.display_order
            ");
            
            $menu = [];
            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $category = $row['category'];
                if (!isset($menu[$category])) {
                    $menu[$category] = [];
                }
                $menu[$category][] = [
                    'name' => $row['name'],
                    'description' => $row['description'],
                    'price' => $row['price']
                ];
            }
            
            // Convert to array of categories with items
            $menuArray = [];
            foreach ($menu as $category => $items) {
                $menuArray[] = [
                    'category' => $category,
                    'items' => $items
                ];
            }
            
            $response = [
                'success' => true,
                'menu' => $menuArray
            ];
            break;

        case 'create_reservation':
            $input = json_decode(file_get_contents('php://input'), true);
            
            $required = ['name', 'email', 'phone', 'date', 'time', 'guests'];
            foreach ($required as $field) {
                if (empty($input[$field])) {
                    throw new Exception("Missing required field: $field");
                }
            }
            
            $stmt = $pdo->prepare("
                INSERT INTO reservations 
                (name, email, phone, reservation_date, reservation_time, guests, special_requests, created_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, NOW())
            ");
            
            $stmt->execute([
                $input['name'],
                $input['email'],
                $input['phone'],
                $input['date'],
                $input['time'],
                $input['guests'],
                $input['special_requests'] ?? ''
            ]);
            
            $response = [
                'success' => true,
                'message' => 'Reservation created successfully',
                'reservation_id' => $pdo->lastInsertId()
            ];
            break;

        case 'contact':
            $input = json_decode(file_get_contents('php://input'), true);
            
            $required = ['name', 'email', 'subject', 'message'];
            foreach ($required as $field) {
                if (empty($input[$field])) {
                    throw new Exception("Missing required field: $field");
                }
            }
            
            $stmt = $pdo->prepare("
                INSERT INTO contact_messages 
                (name, email, subject, message, created_at)
                VALUES (?, ?, ?, ?, NOW())
            ");
            
            $stmt->execute([
                $input['name'],
                $input['email'],
                $input['subject'],
                $input['message']
            ]);
            
            $response = [
                'success' => true,
                'message' => 'Your message has been sent successfully'
            ];
            break;

        default:
            $response['message'] = 'Unknown action';
            break;
    }
} catch (PDOException $e) {
    $response['message'] = 'Database error: ' . $e->getMessage();
} catch (Exception $e) {
    $response['message'] = $e->getMessage();
}

echo json_encode($response);
?>
