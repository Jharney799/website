<?php   // filepath: /home/codespace/website/htdocs/process_form.php
if ($_SERVER["REQUEST_METHOD"] == "POST") {     // Sanitize and validate input
    $name = htmlspecialchars(trim($_POST['name']));
    $email = filter_var(trim($_POST['email']), FILTER_VALIDATE_EMAIL);
    $message = htmlspecialchars(trim($_POST['message']));

    if ($name && $email && $message) {
        // Email configuration
        $to = "jharney@gmail.com";
        $subject = "New Contact Form Submission";
        $headers = "From: $email\r\nReply-To: $email\r\nContent-Type: text/plain; charset=UTF-8";

        // Email body
        $body = "You have received a new message from your website contact form:\n\n";
        $body .= "Name: $name\n";
        $body .= "Email: $email\n\n";
        $body .= "Message:\n$message\n";

        // Send the email
        if (mail($to, $subject, $body, $headers)) {
            echo "Thank you for your message! I will get back to you soon.";
        } else {
            echo "Sorry, there was an error sending your message. Please try again later.";
        }
    } else {
        echo "Please fill out all fields correctly.";
    }
} else {
    echo "Invalid request.";
}
?>