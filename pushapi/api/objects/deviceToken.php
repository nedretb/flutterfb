<?php
class DeviceToken{

    private $conn;
    private $table_name = "app_tokens";

    public $token;

    public function __construct($db){
        $this->conn = $db;
    }

    function read($token){

        $query = "SELECT * FROM " . $this->table_name . " WHERE token=?";
        $stmt = $this->conn->prepare($query);
        $stmt->execute([$token]);

        return $stmt->rowCount();
    }

    function create(){

        $query = "INSERT INTO
                " . $this->table_name . "
            SET
                token=:token";

        $stmt = $this->conn->prepare($query);
        $this->token=htmlspecialchars(strip_tags($this->token));
        $stmt->bindParam(":token", $this->token);

        if($stmt->execute()){
            return true;
        }

        return false;

    }
}
?>