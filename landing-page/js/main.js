// Tab functionality
document.addEventListener('DOMContentLoaded', function() {
    // Hero code tabs
    const tabButtons = document.querySelectorAll('.tab-button');
    const tabContents = document.querySelectorAll('.tab-content');
    
    tabButtons.forEach(button => {
        button.addEventListener('click', () => {
            const targetTab = button.getAttribute('data-tab');
            
            // Update buttons
            tabButtons.forEach(btn => btn.classList.remove('active'));
            button.classList.add('active');
            
            // Update content
            tabContents.forEach(content => {
                if (content.getAttribute('data-content') === targetTab) {
                    content.classList.add('active');
                } else {
                    content.classList.remove('active');
                }
            });
        });
    });
    
    // CLI command selector
    const commandButtons = document.querySelectorAll('.command-btn');
    const commandOutputs = document.querySelectorAll('.command-output');
    
    commandButtons.forEach(button => {
        button.addEventListener('click', () => {
            const targetCommand = button.getAttribute('data-command');
            
            // Update buttons
            commandButtons.forEach(btn => btn.classList.remove('active'));
            button.classList.add('active');
            
            // Update output
            commandOutputs.forEach(output => {
                if (output.getAttribute('data-output') === targetCommand) {
                    output.classList.add('active');
                } else {
                    output.classList.remove('active');
                }
            });
        });
    });
    
    // Copy buttons
    const copyButtons = document.querySelectorAll('.copy-btn');
    
    copyButtons.forEach(button => {
        button.addEventListener('click', async () => {
            const textToCopy = button.getAttribute('data-copy');
            
            try {
                await navigator.clipboard.writeText(textToCopy);
                
                // Visual feedback
                const originalText = button.textContent;
                button.textContent = 'Copied!';
                button.classList.add('copied');
                
                setTimeout(() => {
                    button.textContent = originalText;
                    button.classList.remove('copied');
                }, 2000);
            } catch (err) {
                console.error('Failed to copy:', err);
            }
        });
    });
    
    // Smooth scrolling for navigation links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                const navHeight = document.querySelector('.navbar').offsetHeight;
                const targetPosition = target.offsetTop - navHeight - 20;
                
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
            }
        });
    });
    
    // Navbar shadow on scroll
    const navbar = document.querySelector('.navbar');
    
    window.addEventListener('scroll', () => {
        const currentScroll = window.pageYOffset;
        
        if (currentScroll > 50) {
            navbar.style.boxShadow = '0 2px 8px rgba(0, 0, 0, 0.08)';
        } else {
            navbar.style.boxShadow = 'none';
        }
    });
    
    // Intersection Observer for fade-in animations
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);
    
    // Observe feature cards and example cards
    const animatedElements = document.querySelectorAll('.feature-card, .example-card, .install-card');
    animatedElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(20px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });
    
    // Terminal typing effect for first load
    const terminalContents = document.querySelectorAll('.terminal code');
    const hasVisited = sessionStorage.getItem('hasVisited');
    
    if (!hasVisited && terminalContents.length > 0) {
        sessionStorage.setItem('hasVisited', 'true');
        
        // Store original content
        const originalContent = terminalContents[0].innerHTML;
        terminalContents[0].innerHTML = '';
        
        // Type out content
        let index = 0;
        const typeInterval = setInterval(() => {
            if (index < originalContent.length) {
                terminalContents[0].innerHTML = originalContent.substring(0, index + 1);
                index++;
            } else {
                clearInterval(typeInterval);
            }
        }, 10);
    }
});

// Prevent layout shift on page load
document.addEventListener('DOMContentLoaded', () => {
    document.body.style.opacity = '1';
});