<?php
echo 'ssss';

require __DIR__ . '/vendor/autoload.php';

use Kreait\Firebase\Factory;
use Kreait\Firebase\ServiceAccount;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;


$serviceAccount = ServiceAccount::fromJsonFile('push-repka-firebase-adminsdk-1nulb-574ba28b3d.json');

$firebase = (new Factory)
    ->withServiceAccount($serviceAccount)
    ->create();
//var_dump($serviceAccount);
//var_dump($firebase);

$messaging = $firebase->getMessaging();
// Format Notification
$title = "Most Read Story: " . "title";
$message = "Click here to read the most read story on Novella today.";
$data = [
    'story' => "id"
];

$notification = Notification::fromArray([
    'title' => $title,
    'body' => $message,
    'data' => $data
]);

$message = CloudMessage::withTarget('token', 'dtBbBceeQu-VCP3E1RgQIU:APA91bHAEojFWSvHMZEAst1iHzab1ROoT_tApoHppPXv0kdyaMtx4iSF_lJtNO0Y6uJqO3ZrR215AP52jUISdl20ew8u6EatKXz0Jg6ScK25pyWDpHKXngM7maQ1oINqpy6bgN3nx1mC')
    ->withNotification($notification);

try {
    $messaging->send($message);
} catch (\Kreait\Firebase\Exception\MessagingException $e) {
} catch (\Kreait\Firebase\Exception\FirebaseException $e) {
}
var_dump('done');