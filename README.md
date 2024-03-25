<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <!-- Ensure maximum compatibility and viewport control -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Balaji Digital Marketing</title>
    <!-- Correct path to CSS file assuming styles.css is at the root -->
    <link rel="stylesheet" href="styles.css">
</head>
<body>

    <header>
        <h1>Balaji Digital Marketing</h1>
        <nav aria-label="Main navigation">
            <ul>
                <!-- Ensure that the anchor texts are in the same language as the lang attribute, changing if necessary -->
                <li><a href="#services">Our Services</a></li>
                <li><a href="#about">About Us</a></li>
                <li><a href="#contact">Contact Us</a></li>
            </ul>
        </nav>
    </header>

    <main>
        <section id="services">
            <h2>Our Services</h2>
            <p>Digital Marketing, SEO, Social Media Management, and more...</p>
        </section>

        <section id="about">
            <h2>About Us</h2>
            <p>Balaji Digital Marketing specializes in boosting your brand online.</p>
        </section>

        <section id="contact">
            <h2>Contact Us</h2>
            <form action="your-server-endpoint" method="POST">
                <input type="text" name="name" placeholder="Name" required>
                <input type="email" name="email" placeholder="Email" required>
                <textarea name="message" placeholder="Your Message" required></textarea>
                <button type="submit">Send Message</button>
            </form>
        </section>
    </main>

    <footer>
        <p>© 2023 Balaji Digital Marketing - All Rights Reserved.</p>
    </footer>

</body>
</html>