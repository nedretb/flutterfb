<?php
// required headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../config/database.php';

include_once '../objects/deviceToken.php';

$database = new Database();
$db = $database->getConnection();

$getToken = new DeviceToken($db);

$data = json_decode(file_get_contents("php://input"));

if(!empty($data->token)){

    $checkTokenExists = $getToken->read($data->token);

    if ($checkTokenExists == 1){
    }
    else{
        $getToken->token = $data->token;
        if($getToken->create()){
            http_response_code(201);
            echo json_encode(array("message" => "getToken was created."));
        }
        else{
            http_response_code(503);
            echo json_encode(array("message" => "Unable to store token."));
        }
    }

}
else{
    http_response_code(400);
    echo json_encode(array("message" => "Unable to create getToken. Data is incomplete."));
}
?>