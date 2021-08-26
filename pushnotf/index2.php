<?php
$json_data = [
    "to" => 'dtBbBceeQu-VCP3E1RgQIU:APA91bHAEojFWSvHMZEAst1iHzab1ROoT_tApoHppPXv0kdyaMtx4iSF_lJtNO0Y6uJqO3ZrR215AP52jUISdl20ew8u6EatKXz0Jg6ScK25pyWDpHKXngM7maQ1oINqpy6bgN3nx1mC',
    "notification" => [
        "body" => "SOMETHING",
        "title" => "SOMETHING",
        "icon" => "ic_launcher"
    ]
];

$data = json_encode($json_data);
//FCM API end-point
$url = 'https://fcm.googleapis.com/fcm/send';
//api_key in Firebase Console -> Project Settings -> CLOUD MESSAGING -> Server key
$server_key = 'AAAA7F9o0Wk:APA91bE86IryUKt4OokPytzI3aeF9sJHfjf-5cMR5k1Gx3aAWcCci5FWlAENVv32ura-Uy5TUpzRuuwvfq3T-Z-0j-2_fFn6FSOteaQy9h8AFJ4LZcBeMBnIGxvUt109a5z8Uj2nAjrP';
//header with content_type api key
$headers = array(
    'Content-Type:application/json',
    'Authorization:key='.$server_key
);
//CURL request to route notification to FCM connection server (provided by Google)
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
$result = curl_exec($ch);
if ($result === FALSE) {
    die('Oops! FCM Send Error: ' . curl_error($ch));
}
curl_close($ch);
var_dump($result);
var_dump('done');