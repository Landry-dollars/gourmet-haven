// Mobile Navigation
const burger = document.querySelector('.burger');
const navLinks = document.querySelector('.nav-links');

burger.addEventListener('click', () => {
    navLinks.classList.toggle('active');
});

// Smooth Scrolling for Anchor Links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
        e.preventDefault();
        document.querySelector(this.getAttribute('href')).scrollIntoView({
            behavior: 'smooth'
        });
    });
});

// Image Slider for Specialties
let currentSlide = 0;
const slides = document.querySelectorAll('.specialty-item');
const totalSlides = slides.length;

function showSlide(n) {
    slides.forEach(slide => {
        slide.style.display = 'none';
    });
    
    currentSlide = (n + totalSlides) % totalSlides;
    slides[currentSlide].style.display = 'block';
}

function nextSlide() {
    showSlide(currentSlide + 1);
}

function prevSlide() {
    showSlide(currentSlide - 1);
}

// Initialize first slide
showSlide(0);

// Auto slide change every 5 seconds
setInterval(nextSlide, 5000);

// Form Validation for Reservations
document.getElementById('reservationForm')?.addEventListener('submit', function(e) {
    e.preventDefault();
    
    const name = document.getElementById('name').value;
    const email = document.getElementById('email').value;
    const phone = document.getElementById('phone').value;
    const date = document.getElementById('date').value;
    const time = document.getElementById('time').value;
    const guests = document.getElementById('guests').value;
    
    if (!name || !email || !phone || !date || !time || !guests) {
        alert('Please fill in all fields');
        return;
    }
    
    if (!validateEmail(email)) {
        alert('Please enter a valid email address');
        return;
    }
    
    if (!validatePhone(phone)) {
        alert('Please enter a valid phone number');
        return;
    }
    
    // Submit form if validation passes
    this.submit();
});

function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

function validatePhone(phone) {
    const re = /^[\d\s\-\(\)]{10,15}$/;
    return re.test(phone);
}

// Fetch and display menu items
document.addEventListener('DOMContentLoaded', function() {
    if (document.querySelector('.menu-container')) {
        fetchMenuItems();
    }
});

async function fetchMenuItems() {
    try {
        const response = await fetch('../php/api.php?action=get_menu');
        const data = await response.json();
        
        if (data.success) {
            displayMenuItems(data.menu);
        } else {
            console.error('Error fetching menu:', data.message);
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

function displayMenuItems(menu) {
    const menuContainer = document.querySelector('.menu-container');
    
    menu.forEach(category => {
        const categorySection = document.createElement('div');
        categorySection.className = 'menu-category';
        categorySection.innerHTML = `<h3>${category.category}</h3>`;
        
        const itemsList = document.createElement('div');
        itemsList.className = 'menu-items';
        
        category.items.forEach(item => {
            const itemElement = document.createElement('div');
            itemElement.className = 'menu-item';
            itemElement.innerHTML = `
                <div class="item-name">${item.name}</div>
                <div class="item-description">${item.description}</div>
                <div class="item-price">$${item.price.toFixed(2)}</div>
            `;
            itemsList.appendChild(itemElement);
        });
        
        categorySection.appendChild(itemsList);
        menuContainer.appendChild(categorySection);
    });
}
