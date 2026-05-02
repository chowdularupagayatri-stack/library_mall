<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>City Hospital</title>
    <style>
        body {
            font-family: Arial;
            margin: 0;
            background-color: #f4f8fb;
        }

        header {
            background-color: #0077b6;
            color: white;
            padding: 15px;
            text-align: center;
        }

        nav {
            background-color: #023e8a;
            padding: 10px;
            text-align: center;
        }

        nav a {
            color: white;
            margin: 15px;
            text-decoration: none;
            font-weight: bold;
        }

        nav a:hover {
            color: yellow;
        }

        .hero {
            padding: 50px;
            text-align: center;
            background-color: #caf0f8;
        }

        .section {
            padding: 30px;
        }

        .cards {
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
        }

        .card {
            background: white;
            padding: 20px;
            margin: 10px;
            width: 250px;
            border-radius: 10px;
            box-shadow: 0 0 10px gray;
        }

        footer {
            background-color: #03045e;
            color: white;
            text-align: center;
            padding: 10px;
        }

        input, textarea {
            width: 90%;
            padding: 8px;
            margin: 5px;
        }

        button {
            background-color: #0077b6;
            color: white;
            padding: 10px;
            border: none;
            cursor: pointer;
        }

        button:hover {
            background-color: #023e8a;
        }
    </style>
</head>

<body>

<header>
    <h1>City Hospital</h1>
    <p>Your Health, Our Priority</p>
</header>

<nav>
    <a href="#home">Home</a>
    <a href="#services">Services</a>
    <a href="#doctors">Doctors</a>
    <a href="#contact">Contact</a>
</nav>

<section class="hero" id="home">
    <h2>Welcome to City Hospital</h2>
    <p>24/7 Emergency | Advanced Care | Trusted Doctors</p>
</section>

<section class="section" id="services">
    <h2>Our Services</h2>
    <div class="cards">
        <div class="card">
            <h3>Emergency Care</h3>
            <p>24/7 emergency services available.</p>
        </div>
        <div class="card">
            <h3>Laboratory</h3>
            <p>Advanced diagnostic lab facilities.</p>
        </div>
        <div class="card">
            <h3>Pharmacy</h3>
            <p>All medicines available inside hospital.</p>
        </div>
    </div>
</section>

<section class="section" id="doctors">
    <h2>Our Doctors</h2>
    <div class="cards">
        <div class="card">
            <h3>Dr. Ravi Kumar</h3>
            <p>Cardiologist</p>
        </div>
        <div class="card">
            <h3>Dr. Sneha Reddy</h3>
            <p>Neurologist</p>
        </div>
        <div class="card">
            <h3>Dr. Arjun Rao</h3>
            <p>Orthopedic</p>
        </div>
    </div>
</section>

<section class="section" id="contact">
    <h2>Book Appointment</h2>
    <form onsubmit="submitForm(event)">
        <input type="text" placeholder="Your Name" required><br>
        <input type="email" placeholder="Email" required><br>
        <input type="date" required><br>
        <textarea placeholder="Describe your problem"></textarea><br>
        <button type="submit">Submit</button>
    </form>
    <p id="msg"></p>
</section>

<footer>
    <p>© 2026 City Hospital</p>
</footer>

<script>
function submitForm(e) {
    e.preventDefault();
    document.getElementById("msg").innerHTML = "Appointment Booked Successfully!";
}
</script>

</body>
</html>
