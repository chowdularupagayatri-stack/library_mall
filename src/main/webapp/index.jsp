git status<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HealthPlanner | Preventive Care Assistant</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <style>
        :root {
            --primary: #3b82f6;
            --primary-dark: #2563eb;
            --secondary: #10b981;
            --accent: #8b5cf6;
            --light: #f8fafc;
            --dark: #1e293b;
            --gray: #64748b;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--light);
            color: var(--dark);
        }
        
        .sidebar {
            transition: transform 0.3s ease-in-out;
            transform: translateX(-100%);
            background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
        }
        
        .sidebar-open {
            transform: translateX(0);
        }
        
        @media (min-width: 768px) {
            .sidebar {
                transform: translateX(0);
            }
        }
        
        .nav-item.active {
            background-color: rgba(59, 130, 246, 0.1);
            color: var(--primary);
            border-left: 4px solid var(--primary);
        }
        
        .nav-item.active svg {
            color: var(--primary);
        }
        
        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
            border: 1px solid #e2e8f0;
        }
        
        .btn-primary {
            background-color: var(--primary);
            color: white;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        
        .btn-primary:hover {
            background-color: var(--primary-dark);
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(59, 130, 246, 0.2);
        }
        
        .btn-secondary {
            background-color: white;
            color: var(--primary);
            border: 1px solid var(--primary);
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        
        .btn-secondary:hover {
            background-color: rgba(59, 130, 246, 0.05);
        }
        
        .priority-high {
            background-color: rgba(239, 68, 68, 0.1);
            color: var(--danger);
        }
        
        .priority-medium {
            background-color: rgba(245, 158, 11, 0.1);
            color: var(--warning);
        }
        
        .priority-low {
            background-color: rgba(16, 185, 129, 0.1);
            color: var(--success);
        }
        
        .user-message {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            border-radius: 18px 18px 4px 18px;
        }
        
        .assistant-message {
            background-color: white;
            color: var(--dark);
            border: 1px solid #e2e8f0;
            border-radius: 18px 18px 18px 4px;
        }
        
        .calendar-day {
            transition: all 0.2s ease;
        }
        
        .calendar-day:hover {
            background-color: rgba(59, 130, 246, 0.1);
        }
        
        .calendar-day.today {
            background-color: var(--primary);
            color: white;
            font-weight: 600;
        }
        
        .calendar-day.has-appointment {
            background-color: rgba(16, 185, 129, 0.1);
            color: var(--success);
            font-weight: 500;
        }
        
        .quick-action-card {
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .quick-action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        
        .fade-in {
            animation: fadeIn 0.5s ease-in-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .pulse {
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.7; }
            100% { opacity: 1; }
        }
        
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            max-width: 350px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            transform: translateX(400px);
            transition: transform 0.3s ease;
        }
        
        .notification.show {
            transform: translateX(0);
        }
        
        .notification-alarm {
            background: linear-gradient(135deg, #ff6b6b, #ff8e8e);
            color: white;
        }
        
        .notification-info {
            background: linear-gradient(135deg, #4facfe, #00f2fe);
            color: white;
        }
        
        .notification-success {
            background: linear-gradient(135deg, #43e97b, #38f9d7);
            color: white;
        }
        
        .notification-warning {
            background: linear-gradient(135deg, #fa709a, #fee140);
            color: white;
        }
        
        .alarm-ringing {
            animation: ring 0.5s ease infinite;
        }
        
        @keyframes ring {
            0% { transform: rotate(0deg); }
            25% { transform: rotate(5deg); }
            50% { transform: rotate(0deg); }
            75% { transform: rotate(-5deg); }
            100% { transform: rotate(0deg); }
        }
    </style>
</head>
<body class="min-h-screen flex flex-col">


    <div id="notification-container"></div>


    <div class="flex-1 flex w-full">

  
        <aside id="sidebar" class="sidebar fixed inset-y-0 left-0 z-50 w-64 md:relative md:flex md:flex-col border-r border-slate-200/60 bg-white/90 backdrop-blur-sm shadow-sm">
            <header class="border-b border-slate-200/60 p-6">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 bg-gradient-to-br from-blue-600 to-green-500 rounded-xl flex items-center justify-center shadow-lg">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6 text-white"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
                    </div>
                    <div>
                        <h2 class="font-bold text-slate-900 text-lg">HealthPlanner</h2>
                        <p class="text-xs text-slate-500 font-medium">Preventive Care Assistant</p>
                    </div>
                </div>
            </header>
            <div class="p-3 flex-1">
                <nav class="space-y-1">
                    <h3 class="text-xs font-semibold text-slate-600 uppercase tracking-wider px-3 py-3 mb-2">Navigation</h3>
                    <button class="nav-item w-full text-left p-4 rounded-lg transition-all duration-200 group flex items-center gap-4 active" data-page="home">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-5 h-5 flex-shrink-0"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                        <div class="flex-1">
                            <div class="font-semibold text-sm leading-tight">Health Assistant</div>
                            <div class="text-xs text-slate-500 mt-1 leading-tight">Chat with your health advisor</div>
                        </div>
                    </button>
                    <button class="nav-item w-full text-left p-4 rounded-lg transition-all duration-200 group flex items-center gap-4" data-page="profile">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-5 h-5 flex-shrink-0"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                        <div class="flex-1">
                            <div class="font-semibold text-sm leading-tight">My Profile</div>
                            <div class="text-xs text-slate-500 mt-1 leading-tight">Health information & history</div>
                        </div>
                    </button>
                    <button class="nav-item w-full text-left p-4 rounded-lg transition-all duration-200 group flex items-center gap-4" data-page="careplan">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-5 h-5 flex-shrink-0"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                        <div class="flex-1">
                            <div class="font-semibold text-sm leading-tight">Care Plan</div>
                            <div class="text-xs text-slate-500 mt-1 leading-tight">Personalized recommendations</div>
                        </div>
                    </button>
                    <button class="nav-item w-full text-left p-4 rounded-lg transition-all duration-200 group flex items-center gap-4" data-page="calendar">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-5 h-5 flex-shrink-0"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/></svg>
                        <div class="flex-1">
                            <div class="font-semibold text-sm leading-tight">Calendar</div>
                            <div class="text-xs text-slate-500 mt-1 leading-tight">Appointments & reminders</div>
                        </div>
                    </button>
                    <button class="nav-item w-full text-left p-4 rounded-lg transition-all duration-200 group flex items-center gap-4" data-page="notifications">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-5 h-5 flex-shrink-0"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg>
                        <div class="flex-1">
                            <div class="font-semibold text-sm leading-tight">Notifications</div>
                            <div class="text-xs text-slate-500 mt-1 leading-tight">Alerts & reminders</div>
                        </div>
                    </button>
                </nav>
                
                <div class="mt-8 p-4 bg-gradient-to-r from-blue-50 to-green-50 rounded-xl border border-blue-100">
                    <h3 class="text-sm font-semibold text-slate-800 mb-2">Health Tip</h3>
                    <p class="text-xs text-slate-600">Regular physical activity can help maintain a healthy weight and reduce the risk of chronic diseases.</p>
                </div>
            </div>
            
            <div class="p-4 border-t border-slate-200/60">
                <div class="flex items-center gap-3">
                    <div class="w-8 h-8 bg-gradient-to-br from-blue-500 to-purple-500 rounded-full flex items-center justify-center">
                        <span id="user-initials" class="text-white text-xs font-semibold">JD</span>
                    </div>
                    <div>
                        <p id="user-name" class="text-sm font-medium text-slate-800">John Doe</p>
                        <p class="text-xs text-slate-500">Patient</p>
                    </div>
                </div>
            </div>
        </aside>

     
        <div id="sidebar-overlay" class="fixed inset-0 bg-black/50 z-40 hidden md:hidden"></div>


        <main class="flex-1 flex flex-col bg-gradient-to-br from-slate-50 via-blue-50/30 to-green-50/30">
  
            <header class="md:hidden bg-white/80 backdrop-blur-sm border-b border-slate-200/60 px-6 py-4">
                <div class="flex items-center gap-4">
                    <button id="mobile-menu-button" class="hover:bg-slate-100 p-2 rounded-lg transition-colors duration-200">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-menu"><line x1="4" x2="20" y1="12" y2="12"/><line x1="4" x2="20" y1="6" y2="6"/><line x1="4" x2="20" y1="18" y2="18"/></svg>
                    </button>
                    <div class="flex items-center gap-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6 text-blue-600"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
                        <h1 class="text-lg font-bold text-slate-900">HealthPlanner</h1>
                    </div>
                </div>
            </header>

            <div id="content" class="flex-1 overflow-auto p-4 md:p-6">
        
            </div>
        </main>
    </div>

    <script>
        const appState = {
            currentPage: 'home',
            chatHistory: [
                { 
                    role: 'assistant', 
                    text: "Hello! I'm your personal preventive care assistant. I'm here to help you with health tips, reminders, and preventive care. How can I assist you today?",
                    timestamp: new Date().toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})
                }
            ],
            isChatLoading: false,
            profile: { 
                name: 'John Doe',
                age: '', 
                height: '', 
                weight: '',
                gender: '',
                bloodType: '',
                conditions: []
            },
            appointments: [],
            notifications: [],
            carePlan: {
                vaccines: [
                    { name: "Influenza Vaccine", dueDate: "2024-10-01", priority: "medium", description: "Annual vaccination recommended, especially for those with chronic diseases." },
                    { name: "Tdap (Tetanus, Diphtheria, Pertussis)", dueDate: "2024-05-01", priority: "low", description: "Boost every 10 years; last received likely in 2014." },
                    { name: "Shingles Vaccine (Shingrix)", dueDate: "2025-03-20", priority: "medium", description: "Recommended for adults age 50 and older." },
                    { name: "Pneumococcal Vaccine", dueDate: "2025-03-20", priority: "low", description: "Advised for adults with chronic conditions; ensure current status." }
                ],
                screenings: [
                    { name: "Blood pressure", dueDate: "2024-03-20", priority: "high", description: "Frequency: annually. Continue monitoring due to hypertension." },
                    { name: "Cholesterol (Lipid Panel)", dueDate: "2024-12-31", priority: "high", description: "Frequency: every 5 years. Check due to family history of heart disease." },
                    { name: "Diabetes (Fasting Glucose or HbA1c)", dueDate: "2024-12-31", priority: "high", description: "Frequency: annually. Screening recommended due to family history and age." },
                    { name: "Colorectal Cancer Screening", dueDate: "2026-03-20", priority: "medium", description: "Frequency: every 10 years (or earlier based on findings). Recommended at age 45; start screenings." }
                ]
            }
        };
        
        function getAIResponse(userMessage) {
            const lower = userMessage.toLowerCase();
            
            if (lower.includes("start health assessment") || lower.includes("health assessment")) {
                const profile = JSON.parse(localStorage.getItem('healthProfile') || '{}');
                const { age, height, weight } = profile;

                if (!age || !height || !weight) {
                    return "To provide a comprehensive health assessment, I need your basic health information. Please fill out your age, height, and weight in the 'My Profile' section.";
                }
                
                const bmi = weight / ((height / 100) * (height / 100));
                let bmiStatus = "normal weight";
                let bmiRecommendation = "Great job maintaining a healthy weight!";
                
                if (bmi < 18.5) {
                    bmiStatus = "underweight";
                    bmiRecommendation = "Consider consulting with a nutritionist to develop a healthy weight gain plan.";
                } else if (bmi >= 25 && bmi < 30) {
                    bmiStatus = "overweight";
                    bmiRecommendation = "Focus on balanced nutrition and regular physical activity to reach a healthier weight.";
                } else if (bmi >= 30) {
                    bmiStatus = "obese";
                    bmiRecommendation = "I recommend consulting with a healthcare provider to develop a comprehensive weight management plan.";
                }
                
                return `Based on your profile, your BMI is ${bmi.toFixed(2)}, which falls into the ${bmiStatus} category. ${bmiRecommendation} Would you like specific tips on nutrition, exercise, or other health topics?`;
            }

            if (lower.includes("schedule checkup") || lower.includes("book appointment")) {
                return "You can schedule appointments using the Calendar tab. Just click on any date to add a new appointment. I recommend regular checkups at least once a year for preventive care.";
            }

            if (lower.includes("lifestyle guidance") || lower.includes("healthy habits")) {
                return "To improve your daily habits, I recommend focusing on these key areas: balanced nutrition, regular physical activity, quality sleep, stress management, and hydration. Which specific area would you like to know more about?";
            }
            
            if (lower.includes("care guidelines") || lower.includes("health recommendations")) {
                return "I can provide evidence-based recommendations for preventive care. Check the 'Care Plan' section for personalized vaccine and screening recommendations based on your profile. Is there a specific health concern you'd like to discuss?";
            }

            if (lower.includes("diet") || lower.includes("food") || lower.includes("nutrition")) {
                return "A balanced diet should include plenty of vegetables, fruits, whole grains, lean proteins, and healthy fats. Try to limit processed foods, sugary drinks, and excessive salt. The Mediterranean diet is often recommended for its heart health benefits.";
            }
            
            if (lower.includes("exercise") || lower.includes("workout") || lower.includes("physical activity")) {
                return "Aim for at least 150 minutes of moderate-intensity aerobic activity or 75 minutes of vigorous activity each week, plus muscle-strengthening activities 2 days per week. Even short bouts of activity throughout the day can add up!";
            }
            
            if (lower.includes("water") || lower.includes("drink") || lower.includes("hydration")) {
                return "Most adults need about 2-3 liters of fluids daily, preferably water. Your exact needs depend on your activity level, climate, and overall health. A good indicator of hydration is pale yellow urine.";
            }
            
            if (lower.includes("sleep") || lower.includes("rest")) {
                return "Adults typically need 7-9 hours of quality sleep per night. Good sleep hygiene includes maintaining a consistent sleep schedule, creating a restful environment, and avoiding screens before bedtime.";
            }
            
            if (lower.includes("stress") || lower.includes("mental") || lower.includes("anxiety")) {
                return "Managing stress is crucial for overall health. Techniques like mindfulness meditation, deep breathing exercises, regular physical activity, and maintaining social connections can all help reduce stress levels.";
            }
            
            if (lower.includes("blood pressure") || lower.includes("hypertension")) {
                return "Normal blood pressure is typically below 120/80 mmHg. Lifestyle changes like reducing sodium intake, increasing physical activity, and managing stress can help maintain healthy blood pressure levels.";
            }
            
            if (lower.includes("cholesterol")) {
                return "Healthy cholesterol levels are important for heart health. Aim for total cholesterol under 200 mg/dL, LDL ('bad') cholesterol under 100 mg/dL, and HDL ('good') cholesterol above 60 mg/dL. A diet low in saturated fats and high in fiber can help.";
            }
            
            if (lower.includes("vaccine") || lower.includes("immunization")) {
                return "Vaccines are an important part of preventive care. Check the 'Care Plan' section for your personalized vaccine recommendations based on your age and health status.";
            }
            
            if (lower.includes("screening") || lower.includes("test")) {
                return "Regular health screenings can detect potential issues early. The 'Care Plan' section provides personalized screening recommendations based on your age, gender, and health history.";
            }

            if (lower.includes("hello") || lower.includes("hi") || lower.includes("hey")) {
                return "Hello! How are you feeling today? I'm here to help with your preventive health needs. 😊";
            }
            
            if (lower.includes("thank")) {
                return "You're welcome! I'm happy to help with your health questions. Is there anything else you'd like to know?";
            }
            
            return "I'm here to help with preventive care, nutrition, exercise, sleep, stress management, and general health questions. You can also ask about specific conditions, medications, or check the 'Care Plan' section for personalized recommendations. What would you like to know more about?";
        }

        const pages = {
            home: `
                <div class="space-y-6 fade-in">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 bg-gradient-to-br from-blue-600 to-green-500 rounded-xl flex items-center justify-center shadow-lg">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6 text-white"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                        </div>
                        <div>
                            <h1 class="text-2xl font-bold text-slate-800">Health Assistant</h1>
                            <p class="text-slate-500">Your personalized preventive care advisor</p>
                        </div>
                    </div>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="card p-6">
                            <h3 class="text-lg font-semibold text-slate-800 mb-4">Quick Actions</h3>
                            <div class="space-y-4">
                                <div class="quick-action-card card p-4 border border-slate-200" id="quick-action-assessment">
                                    <div class="flex items-center gap-3">
                                        <div class="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-blue-600"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                                        </div>
                                        <div>
                                            <h4 class="font-medium text-slate-800">Health Assessment</h4>
                                            <p class="text-xs text-slate-500">Get personalized recommendations</p>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="quick-action-card card p-4 border border-slate-200" id="quick-action-checkup">
                                    <div class="flex items-center gap-3">
                                        <div class="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-green-600"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/></svg>
                                        </div>
                                        <div>
                                            <h4 class="font-medium text-slate-800">Schedule Checkup</h4>
                                            <p class="text-xs text-slate-500">Book preventive care appointments</p>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="quick-action-card card p-4 border border-slate-200" id="quick-action-guidance">
                                    <div class="flex items-center gap-3">
                                        <div class="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-purple-600"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                                        </div>
                                        <div>
                                            <h4 class="font-medium text-slate-800">Lifestyle Guidance</h4>
                                            <p class="text-xs text-slate-500">Improve your daily health habits</p>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="quick-action-card card p-4 border border-slate-200" id="quick-action-guidelines">
                                    <div class="flex items-center gap-3">
                                        <div class="w-10 h-10 bg-amber-100 rounded-lg flex items-center justify-center">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-amber-600"><path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/><polyline points="14 2 14 8 20 8"/><line x1="10" y1="13" x2="14" y2="13"/><line x1="10" y1="17" x2="14" y2="17"/><line x1="10" y1="9" x2="10" y2="9"/></svg>
                                        </div>
                                        <div>
                                            <h4 class="font-medium text-slate-800">Care Guidelines</h4>
                                            <p class="text-xs text-slate-500">Evidence-based health recommendations</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="card p-6">
                            <h3 class="text-lg font-semibold text-slate-800 mb-4">Health Summary</h3>
                            <div id="health-summary" class="space-y-4">
                                <!-- Health summary will be dynamically populated -->
                                <div class="text-center py-8 text-slate-400">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-12 h-12 mx-auto mb-2"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                                    <p>Complete your profile to see your health summary</p>
                                    <button class="mt-2 text-blue-600 font-medium" data-page="profile">Go to Profile</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card p-6">
                        <h3 class="text-lg font-semibold text-slate-800 mb-4">Chat with Health Assistant</h3>
                        <div id="chat-container" class="h-64 overflow-y-auto mb-4 space-y-4 p-2">
                            <!-- Chat messages will be rendered here -->
                        </div>
                        
                        <div class="flex gap-2">
                            <input id="chat-input" type="text" class="flex-1 px-4 py-3 bg-slate-50 rounded-lg border border-slate-300 text-slate-800 focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Type your health question..." />
                            <button id="send-button" class="btn-primary px-4 py-3 flex items-center gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m22 2-7 20-4-9-9-4 20-7Z"/><path d="M22 2 11 13"/></svg>
                                <span>Send</span>
                            </button>
                        </div>
                    </div>
                </div>
            `,
            profile: `
                <div class="space-y-6 fade-in">
                    <div class="flex items-center justify-between">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 bg-gradient-to-br from-blue-600 to-green-500 rounded-xl flex items-center justify-center shadow-lg">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6 text-white"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                            </div>
                            <div>
                                <h1 class="text-2xl font-bold text-slate-800">My Profile</h1>
                                <p class="text-slate-500">Manage your health information and history</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                        <div class="lg:col-span-2 card p-6">
                            <h3 class="text-lg font-semibold text-slate-800 mb-4">Personal Information</h3>
                            <form id="profile-form" class="space-y-4">
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <label for="profile-name" class="block text-sm font-medium text-slate-700 mb-1">Full Name</label>
                                        <input type="text" id="profile-name" class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Enter your full name">
                                    </div>
                                    <div>
                                        <label for="profile-age" class="block text-sm font-medium text-slate-700 mb-1">Age</label>
                                        <input type="number" id="profile-age" class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Enter your age">
                                    </div>
                                </div>
                                
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <label for="profile-height" class="block text-sm font-medium text-slate-700 mb-1">Height (cm)</label>
                                        <input type="number" id="profile-height" class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Enter your height">
                                    </div>
                                    <div>
                                        <label for="profile-weight" class="block text-sm font-medium text-slate-700 mb-1">Weight (kg)</label>
                                        <input type="number" id="profile-weight" class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Enter your weight">
                                    </div>
                                </div>
                                
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <label for="profile-gender" class="block text-sm font-medium text-slate-700 mb-1">Gender</label>
                                        <select id="profile-gender" class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                                            <option value="">Select gender</option>
                                            <option value="male">Male</option>
                                            <option value="female">Female</option>
                                            <option value="other">Other</option>
                                        </select>
                                    </div>
                                    <div>
                                        <label for="profile-blood-type" class="block text-sm font-medium text-slate-700 mb-1">Blood Type</label>
                                        <select id="profile-blood-type" class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                                            <option value="">Select blood type</option>
                                            <option value="a+">A+</option>
                                            <option value="a-">A-</option>
                                            <option value="b+">B+</option>
                                            <option value="b-">B-</option>
                                            <option value="ab+">AB+</option>
                                            <option value="ab-">AB-</option>
                                            <option value="o+">O+</option>
                                            <option value="o-">O-</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div>
                                    <label for="profile-conditions" class="block text-sm font-medium text-slate-700 mb-1">Health Conditions (comma separated)</label>
                                    <input type="text" id="profile-conditions" class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="e.g., Hypertension, Diabetes">
                                </div>
                                
                                <button type="submit" id="save-profile-button" class="w-full btn-primary py-3 font-semibold">Save Profile</button>
                            </form>
                        </div>
                        
                        <div class="card p-6">
                            <h3 class="text-lg font-semibold text-slate-800 mb-4">Health Summary</h3>
                            <div id="profile-details" class="space-y-4">
                                <!-- Profile details will be dynamically populated -->
                                <div class="text-center py-8 text-slate-400">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-12 h-12 mx-auto mb-2"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                                    <p>Complete your profile to see your health summary</p>
                                </div>
                            </div>
                            
                            <div class="mt-6 p-4 bg-blue-50 rounded-lg border border-blue-100">
                                <h4 class="font-medium text-blue-800 mb-2">Profile Completion</h4>
                                <div class="w-full bg-blue-200 rounded-full h-2">
                                    <div id="profile-completion-bar" class="bg-blue-600 h-2 rounded-full" style="width: 0%"></div>
                                </div>
                                <p id="profile-completion-text" class="text-xs text-blue-700 mt-1">0% complete</p>
                            </div>
                        </div>
                    </div>
                </div>
            `,
            careplan: `
                <div class="space-y-6 fade-in">
                    <div class="flex justify-between items-center flex-wrap gap-4">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 bg-gradient-to-br from-blue-600 to-green-500 rounded-xl flex items-center justify-center shadow-lg">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6 text-white"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                            </div>
                            <div>
                                <h1 class="text-2xl font-bold text-slate-800">My Care Plan</h1>
                                <p class="text-slate-500">Personalized preventive health recommendations</p>
                            </div>
                        </div>
                        <div class="flex gap-2">
                            <button id="export-pdf-button" class="btn-secondary px-4 py-2 flex items-center gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" x2="12" y1="15" y2="3"/></svg>
                                <span>Export PDF</span>
                            </button>
                            <button id="generate-new-plan-button" class="btn-primary px-4 py-2 flex items-center gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12a9 9 0 0 1-9 9m9-9a9 9 0 0 0-9-9m9 9H3m9 9v-9m0-9v9"/></svg>
                                <span>Refresh Plan</span>
                            </button>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                        <div class="card p-6">
                            <h3 class="text-xl font-semibold mb-4 text-slate-800 flex items-center gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6 text-blue-600"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
                                Recommended Vaccines
                            </h3>
                            <div id="vaccines-list" class="space-y-4">
                                <!-- Vaccines will be dynamically populated -->
                            </div>
                        </div>

                        <div class="card p-6">
                            <h3 class="text-xl font-semibold mb-4 text-slate-800 flex items-center gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6 text-blue-600"><path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/><polyline points="14 2 14 8 20 8"/><line x1="10" y1="13" x2="14" y2="13"/><line x1="10" y1="17" x2="14" y2="17"/><line x1="10" y1="9" x2="10" y2="9"/></svg>
                                Recommended Screenings
                            </h3>
                            <div id="screenings-list" class="space-y-4">
                                <!-- Screenings will be dynamically populated -->
                            </div>
                        </div>
                    </div>
                    
                    <div class="card p-6">
                        <h3 class="text-xl font-semibold mb-4 text-slate-800">Lifestyle Recommendations</h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                            <div class="p-4 bg-blue-50 rounded-lg border border-blue-100">
                                <div class="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center mb-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-blue-600"><path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0z"/></svg>
                                </div>
                                <h4 class="font-semibold text-slate-800 mb-1">Nutrition</h4>
                                <p class="text-sm text-slate-600">Focus on whole foods, fruits, vegetables, and lean proteins.</p>
                            </div>
                            
                            <div class="p-4 bg-green-50 rounded-lg border border-green-100">
                                <div class="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center mb-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-green-600"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
                                </div>
                                <h4 class="font-semibold text-slate-800 mb-1">Exercise</h4>
                                <p class="text-sm text-slate-600">Aim for 150 minutes of moderate activity per week.</p>
                            </div>
                            
                            <div class="p-4 bg-purple-50 rounded-lg border border-purple-100">
                                <div class="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center mb-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-purple-600"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
                                </div>
                                <h4 class="font-semibold text-slate-800 mb-1">Sleep</h4>
                                <p class="text-sm text-slate-600">Target 7-9 hours of quality sleep per night.</p>
                            </div>
                            
                            <div class="p-4 bg-amber-50 rounded-lg border border-amber-100">
                                <div class="w-10 h-10 bg-amber-100 rounded-lg flex items-center justify-center mb-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-amber-600"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/></svg>
                                </div>
                                <h4 class="font-semibold text-slate-800 mb-1">Stress Management</h4>
                                <p class="text-sm text-slate-600">Practice mindfulness and relaxation techniques.</p>
                            </div>
                        </div>
                    </div>
                </div>
            `,
            calendar: `
                <div class="space-y-6 fade-in">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 bg-gradient-to-br from-blue-600 to-green-500 rounded-xl flex items-center justify-center shadow-lg">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6 text-white"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/></svg>
                        </div>
                        <div>
                            <h1 class="text-2xl font-bold text-slate-800">Calendar</h1>
                            <p class="text-slate-500">Manage your health appointments and reminders</p>
                        </div>
                    </div>
                    
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                        <div class="lg:col-span-2 card p-6">
                            <div class="flex justify-between items-center mb-6">
                                <button id="prev-month" class="p-2 rounded-full hover:bg-slate-100 transition-colors">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
                                </button>
                                <h3 id="month-year" class="text-lg font-semibold text-slate-700"></h3>
                                <button id="next-month" class="p-2 rounded-full hover:bg-slate-100 transition-colors">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"/></svg>
                                </button>
                            </div>
                            <div class="grid grid-cols-7 gap-1 text-center font-medium text-sm text-slate-500 mb-2">
                                <span>Sun</span><span>Mon</span><span>Tue</span><span>Wed</span><span>Thu</span><span>Fri</span><span>Sat</span>
                            </div>
                            <div id="calendar-days" class="grid grid-cols-7 gap-1 w-full text-center"></div>
                        </div>
                        
                        <div class="card p-6">
                            <h3 class="text-lg font-semibold text-slate-800 mb-4">Upcoming Appointments</h3>
                            <div id="appointment-list" class="space-y-4">
                                <!-- Appointments will be dynamically populated -->
                                <div class="text-center py-8 text-slate-400">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-12 h-12 mx-auto mb-2"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/></svg>
                                    <p>No upcoming appointments</p>
                                    <button class="mt-2 text-blue-600 font-medium" id="add-first-appointment">Add your first appointment</button>
                                </div>
                            </div>
                            
                            <button id="add-appointment-button" class="w-full mt-4 btn-primary py-3 flex items-center justify-center gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5v14"/><path d="M5 12h14"/></svg>
                                <span>Add New Appointment</span>
                            </button>
                        </div>
                    </div>
                </div>
            `,
            notifications: `
                <div class="space-y-6 fade-in">
                    <div class="flex items-center justify-between">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 bg-gradient-to-br from-blue-600 to-green-500 rounded-xl flex items-center justify-center shadow-lg">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6 text-white"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg>
                            </div>
                            <div>
                                <h1 class="text-2xl font-bold text-slate-800">Notifications</h1>
                                <p class="text-slate-500">Manage your health alerts and reminders</p>
                            </div>
                        </div>
                        <div class="flex gap-2">
                            <button id="test-alarm-button" class="btn-primary px-4 py-2 flex items-center gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22c5.523 0 10-4.477 10-10S17.523 2 12 2 2 6.477 2 12s4.477 10 10 10z"/><path d="m9 12 2 2 4-4"/></svg>
                                <span>Test Alarm</span>
                            </button>
                            <button id="clear-all-notifications" class="btn-secondary px-4 py-2 flex items-center gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"/><path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/><path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/></svg>
                                <span>Clear All</span>
                            </button>
                        </div>
                    </div>
                    
                    <div class="card p-6">
                        <h3 class="text-lg font-semibold text-slate-800 mb-4">Notification Settings</h3>
                        <div class="space-y-4">
                            <div class="flex items-center justify-between p-4 bg-slate-50 rounded-lg border border-slate-200">
                                <div>
                                    <h4 class="font-medium text-slate-800">Appointment Reminders</h4>
                                    <p class="text-sm text-slate-600">Get notified before your appointments</p>
                                </div>
                                <label class="relative inline-flex items-center cursor-pointer">
                                    <input type="checkbox" id="appointment-reminders" class="sr-only peer" checked>
                                    <div class="w-11 h-6 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
                                </label>
                            </div>
                            
                            <div class="flex items-center justify-between p-4 bg-slate-50 rounded-lg border border-slate-200">
                                <div>
                                    <h4 class="font-medium text-slate-800">Medication Reminders</h4>
                                    <p class="text-sm text-slate-600">Get reminders for your medications</p>
                                </div>
                                <label class="relative inline-flex items-center cursor-pointer">
                                    <input type="checkbox" id="medication-reminders" class="sr-only peer" checked>
                                    <div class="w-11 h-6 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
                                </label>
                            </div>
                            
                            <div class="flex items-center justify-between p-4 bg-slate-50 rounded-lg border border-slate-200">
                                <div>
                                    <h4 class="font-medium text-slate-800">Health Tips</h4>
                                    <p class="text-sm text-slate-600">Receive daily health tips and advice</p>
                                </div>
                                <label class="relative inline-flex items-center cursor-pointer">
                                    <input type="checkbox" id="health-tips" class="sr-only peer" checked>
                                    <div class="w-11 h-6 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
                                </label>
                            </div>
                            
                            <div class="flex items-center justify-between p-4 bg-slate-50 rounded-lg border border-slate-200">
                                <div>
                                    <h4 class="font-medium text-slate-800">Care Plan Updates</h4>
                                    <p class="text-sm text-slate-600">Get notified about care plan changes</p>
                                </div>
                                <label class="relative inline-flex items-center cursor-pointer">
                                    <input type="checkbox" id="care-plan-updates" class="sr-only peer" checked>
                                    <div class="w-11 h-6 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
                                </label>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card p-6">
                        <h3 class="text-lg font-semibold text-slate-800 mb-4">Recent Notifications</h3>
                        <div id="notifications-list" class="space-y-4">
                            <!-- Notifications will be dynamically populated -->
                            <div class="text-center py-8 text-slate-400">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-12 h-12 mx-auto mb-2"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg>
                                <p>No notifications yet</p>
                            </div>
                        </div>
                    </div>
                </div>
            `
        };

        const renderPage = (pageName) => {
            const contentDiv = document.getElementById('content');
            if (contentDiv) {
                contentDiv.innerHTML = pages[pageName] || '';
                attachEventListeners(pageName);
                
                if (pageName === 'home') {
                    renderChat();
                    renderHealthSummary();
                } else if (pageName === 'profile') {
                    loadProfile();
                } else if (pageName === 'careplan') {
                    renderCarePlan();
                } else if (pageName === 'calendar') {
                    renderCalendar();
                } else if (pageName === 'notifications') {
                    renderNotifications();
                }
            }
        };

        const attachEventListeners = (pageName) => {
            if (pageName === 'home') {
                document.getElementById('send-button').addEventListener('click', sendMessage);
                document.getElementById('chat-input').addEventListener('keydown', (e) => {
                    if (e.key === 'Enter') sendMessage();
                });
                
                document.getElementById('quick-action-assessment').addEventListener('click', () => {
                    sendMessage('Start Health Assessment');
                });
                document.getElementById('quick-action-checkup').addEventListener('click', () => {
                    sendMessage('Schedule Checkup');
                });
                document.getElementById('quick-action-guidance').addEventListener('click', () => {
                    sendMessage('Lifestyle Guidance');
                });
                document.getElementById('quick-action-guidelines').addEventListener('click', () => {
                    sendMessage('Care Guidelines');
                });
                
            
                const profileLink = document.querySelector('[data-page="profile"]');
                if (profileLink) {
                    profileLink.addEventListener('click', (e) => {
                        e.preventDefault();
                        renderPage('profile');
                        updateNavButtons('profile');
                    });
                }
                
            } else if (pageName === 'careplan') {
                document.getElementById('export-pdf-button').addEventListener('click', handleGeneratePDF);
                document.getElementById('generate-new-plan-button').addEventListener('click', handleGenerateNewPlan);
            } else if (pageName === 'profile') {
                document.getElementById('profile-form').addEventListener('submit', handleSaveProfile);
            } else if (pageName === 'calendar') {
                document.getElementById('prev-month').addEventListener('click', () => {
                    currentDate.setMonth(currentDate.getMonth() - 1);
                    renderCalendar();
                });
                document.getElementById('next-month').addEventListener('click', () => {
                    currentDate.setMonth(currentDate.getMonth() + 1);
                    renderCalendar();
                });
                document.getElementById('add-appointment-button').addEventListener('click', () => {
                    handleAddAppointment();
                });
                document.getElementById('add-first-appointment').addEventListener('click', () => {
                    handleAddAppointment();
                });
            } else if (pageName === 'notifications') {
                document.getElementById('test-alarm-button').addEventListener('click', testAlarm);
                document.getElementById('clear-all-notifications').addEventListener('click', clearAllNotifications);
                
                document.getElementById('appointment-reminders').addEventListener('change', saveNotificationSettings);
                document.getElementById('medication-reminders').addEventListener('change', saveNotificationSettings);
                document.getElementById('health-tips').addEventListener('change', saveNotificationSettings);
                document.getElementById('care-plan-updates').addEventListener('change', saveNotificationSettings);
                
                loadNotificationSettings();
            }
        };

        const updateNavButtons = (activePage) => {
            document.querySelectorAll('.nav-item').forEach(button => {
                const page = button.getAttribute('data-page');
                if (page === activePage) {
                    button.classList.add('active');
                } else {
                    button.classList.remove('active');
                }
            });
        };

        function renderChat() {
            const chatContainer = document.getElementById("chat-container");
            if (!chatContainer) return;
            chatContainer.innerHTML = "";

            appState.chatHistory.forEach(msg => {
                const messageDiv = document.createElement("div");
                messageDiv.className = `flex ${msg.role === "user" ? "justify-end" : "justify-start"}`;
                
                messageDiv.innerHTML = `
                    <div class="max-w-xs md:max-w-md ${msg.role === "user" ? "user-message" : "assistant-message"} p-3 shadow-sm">
                        <p class="text-sm">${msg.text}</p>
                        <p class="text-xs mt-1 ${msg.role === "user" ? "text-blue-100" : "text-slate-400"}">${msg.timestamp}</p>
                    </div>
                `;
                chatContainer.appendChild(messageDiv);
            });

            chatContainer.scrollTop = chatContainer.scrollHeight;
        }


        function sendMessage(messageText) {
            const input = document.getElementById("chat-input");
            const text = messageText || input.value.trim();
            if (!text) return;

            
            appState.chatHistory.push({ 
                role: "user", 
                text,
                timestamp: new Date().toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})
            });
            renderChat();


            if (!messageText) input.value = "";


            const chatContainer = document.getElementById("chat-container");
            const typingDiv = document.createElement("div");
            typingDiv.className = "flex justify-start";
            typingDiv.innerHTML = `
                <div class="assistant-message p-3 shadow-sm">
                    <div class="flex space-x-1">
                        <div class="w-2 h-2 bg-slate-400 rounded-full animate-pulse"></div>
                        <div class="w-2 h-2 bg-slate-400 rounded-full animate-pulse" style="animation-delay: 0.2s"></div>
                        <div class="w-2 h-2 bg-slate-400 rounded-full animate-pulse" style="animation-delay: 0.4s"></div>
                    </div>
                </div>
            `;
            chatContainer.appendChild(typingDiv);
            chatContainer.scrollTop = chatContainer.scrollHeight;

    
            setTimeout(() => {
               
                typingDiv.remove();
                
             
                const reply = getAIResponse(text);
                appState.chatHistory.push({ 
                    role: "assistant", 
                    text: reply,
                    timestamp: new Date().toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})
                });
                renderChat();
                
          
                if (text.toLowerCase().includes("health assessment") || 
                    text.toLowerCase().includes("bmi") || 
                    text.toLowerCase().includes("profile")) {
                    renderHealthSummary();
                }
            }, 1000 + Math.random() * 1000); 
        }

    
        const handleGeneratePDF = () => {
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF();
            
            const title = "My Care Plan";
            const subtitle = "Personalized preventive health recommendations";
            const margin = 20;
            let y = margin;
            const lineHeight = 7;
            

            doc.setFontSize(22);
            doc.setTextColor(59, 130, 246);
            doc.text(title, margin, y);
            y += lineHeight;
            

            doc.setFontSize(12);
            doc.setTextColor(100, 116, 139);
            doc.text(subtitle, margin, y);
            y += lineHeight * 2;
            
     
            const profile = JSON.parse(localStorage.getItem('healthProfile') || '{}');
            if (profile.name || profile.age) {
                doc.setFontSize(14);
                doc.setTextColor(30, 41, 59);
                doc.text("Patient Information", margin, y);
                y += lineHeight;
                
                doc.setFontSize(10);
                if (profile.name) doc.text(`Name: ${profile.name}`, margin, y);
                y += lineHeight;
                if (profile.age) doc.text(`Age: ${profile.age}`, margin, y);
                y += lineHeight;
                if (profile.gender) doc.text(`Gender: ${profile.gender}`, margin, y);
                y += lineHeight;
                if (profile.bloodType) doc.text(`Blood Type: ${profile.bloodType}`, margin, y);
                y += lineHeight * 2;
            }
            
   
            const addSection = (sectionTitle, items) => {
                doc.setFontSize(16);
                doc.setTextColor(30, 41, 59);
                doc.text(sectionTitle, margin, y);
                y += lineHeight;
                doc.setFontSize(10);
                
                items.forEach(item => {
                    if (y > 270) {
                        doc.addPage();
                        y = margin;
                    }
                    
                    doc.setTextColor(30, 41, 59);
                    doc.text(`• ${item.name}`, margin + 5, y);
                    y += lineHeight;
                    
                    doc.setTextColor(100, 116, 139);
                    doc.text(`Due: ${item.dueDate}`, margin + 10, y);
                    y += lineHeight;
                    
                    doc.text(item.description, margin + 10, y, { maxWidth: 170 });
                    y += lineHeight * 2;
                });
                y += lineHeight;
            };

 
            addSection("Recommended Vaccines", appState.carePlan.vaccines);
            addSection("Recommended Screenings", appState.carePlan.screenings);
            
      
            doc.save("HealthPlanner_CarePlan.pdf");
            

            showNotification("Care plan exported successfully!", "success");
        };

        const handleGenerateNewPlan = () => {
      
            const button = document.getElementById('generate-new-plan-button');
            const originalText = button.innerHTML;
            button.innerHTML = `
                <div class="flex items-center gap-2">
                    <div class="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                    <span>Generating...</span>
                </div>
            `;
            button.disabled = true;
            

            setTimeout(() => {
            
                const today = new Date();
                const nextMonth = new Date(today.getFullYear(), today.getMonth() + 1, 1);
                const nextYear = new Date(today.getFullYear() + 1, today.getMonth(), 1);
                
            
                appState.carePlan.vaccines.forEach(vaccine => {
                    vaccine.dueDate = formatDate(nextMonth);
                    nextMonth.setDate(nextMonth.getDate() + 30);
                });
                
                appState.carePlan.screenings.forEach(screening => {
                    screening.dueDate = formatDate(nextYear);
                });
                
           
                renderCarePlan();
                
              
                button.innerHTML = originalText;
                button.disabled = false;
                
                
                showNotification("New care plan generated successfully!", "success");
            }, 1500);
        };

        
        const handleSaveProfile = (e) => {
            e.preventDefault();
            const name = document.getElementById('profile-name').value;
            const age = document.getElementById('profile-age').value;
            const height = document.getElementById('profile-height').value;
            const weight = document.getElementById('profile-weight').value;
            const gender = document.getElementById('profile-gender').value;
            const bloodType = document.getElementById('profile-blood-type').value;
            const conditions = document.getElementById('profile-conditions').value.split(',').map(c => c.trim()).filter(c => c);
            
            appState.profile = { name, age, height, weight, gender, bloodType, conditions };
            localStorage.setItem('healthProfile', JSON.stringify(appState.profile));
            
       
            updateUserName();
            
     
            updateCarePlanBasedOnProfile();
            
            renderProfile();
            showNotification("Profile saved successfully!", "success");
        };

        const loadProfile = () => {
            const savedProfile = localStorage.getItem('healthProfile');
            if (savedProfile) {
                appState.profile = JSON.parse(savedProfile);
                updateUserName();
            }
            renderProfile();
        };

        const renderProfile = () => {
            const profileDetails = document.getElementById('profile-details');
            const completionBar = document.getElementById('profile-completion-bar');
            const completionText = document.getElementById('profile-completion-text');
            
            if (!profileDetails) return;
            
        
            const fields = ['name', 'age', 'height', 'weight', 'gender', 'bloodType'];
            let completed = 0;
            fields.forEach(field => {
                if (appState.profile[field]) completed++;
            });
            const completionPercentage = Math.round((completed / fields.length) * 100);
            
       
            if (completionBar) {
                completionBar.style.width = `${completionPercentage}%`;
            }
            if (completionText) {
                completionText.textContent = `${completionPercentage}% complete`;
            }
            
            
            document.getElementById('profile-name').value = appState.profile.name || '';
            document.getElementById('profile-age').value = appState.profile.age || '';
            document.getElementById('profile-height').value = appState.profile.height || '';
            document.getElementById('profile-weight').value = appState.profile.weight || '';
            document.getElementById('profile-gender').value = appState.profile.gender || '';
            document.getElementById('profile-blood-type').value = appState.profile.bloodType || '';
            document.getElementById('profile-conditions').value = appState.profile.conditions.join(', ') || '';
            
            
            if (completionPercentage > 0) {
                profileDetails.innerHTML = `
                    <div class="space-y-3">
                        ${appState.profile.name ? `<div class="flex justify-between"><span class="text-slate-600">Name:</span><span class="font-medium text-slate-800">${appState.profile.name}</span></div>` : ''}
                        ${appState.profile.age ? `<div class="flex justify-between"><span class="text-slate-600">Age:</span><span class="font-medium text-slate-800">${appState.profile.age} years</span></div>` : ''}
                        ${appState.profile.height ? `<div class="flex justify-between"><span class="text-slate-600">Height:</span><span class="font-medium text-slate-800">${appState.profile.height} cm</span></div>` : ''}
                        ${appState.profile.weight ? `<div class="flex justify-between"><span class="text-slate-600">Weight:</span><span class="font-medium text-slate-800">${appState.profile.weight} kg</span></div>` : ''}
                        ${appState.profile.gender ? `<div class="flex justify-between"><span class="text-slate-600">Gender:</span><span class="font-medium text-slate-800">${appState.profile.gender}</span></div>` : ''}
                        ${appState.profile.bloodType ? `<div class="flex justify-between"><span class="text-slate-600">Blood Type:</span><span class="font-medium text-slate-800">${appState.profile.bloodType.toUpperCase()}</span></div>` : ''}
                        ${appState.profile.conditions.length > 0 ? `
                            <div>
                                <span class="text-slate-600">Health Conditions:</span>
                                <div class="mt-1 flex flex-wrap gap-1">
                                    ${appState.profile.conditions.map(condition => 
                                        `<span class="px-2 py-1 bg-slate-100 text-slate-700 rounded-full text-xs">${condition}</span>`
                                    ).join('')}
                                </div>
                            </div>
                        ` : ''}
                        
                        ${appState.profile.height && appState.profile.weight ? `
                            <div class="pt-3 border-t border-slate-200">
                                <div class="flex justify-between items-center">
                                    <span class="text-slate-600">BMI:</span>
                                    <span class="font-medium text-slate-800">${calculateBMI(appState.profile.height, appState.profile.weight)}</span>
                                </div>
                                <div class="mt-1 text-xs text-slate-500">${getBMICategory(calculateBMI(appState.profile.height, appState.profile.weight))}</div>
                            </div>
                        ` : ''}
                    </div>
                `;
            } else {
                profileDetails.innerHTML = `
                    <div class="text-center py-8 text-slate-400">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-12 h-12 mx-auto mb-2"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                        <p>Complete your profile to see your health summary</p>
                    </div>
                `;
            }
        };

    
        function updateUserName() {
            const userNameElement = document.getElementById('user-name');
            const userInitialsElement = document.getElementById('user-initials');
            
            if (appState.profile.name && appState.profile.name !== 'John Doe') {
                userNameElement.textContent = appState.profile.name;
                
              
                const initials = appState.profile.name
                    .split(' ')
                    .map(part => part.charAt(0))
                    .join('')
                    .toUpperCase()
                    .substring(0, 2);
                
                userInitialsElement.textContent = initials;
            } else {
                userNameElement.textContent = 'John Doe';
                userInitialsElement.textContent = 'JD';
            }
        }

       
        function renderHealthSummary() {
            const healthSummary = document.getElementById('health-summary');
            if (!healthSummary) return;
            
            const profile = JSON.parse(localStorage.getItem('healthProfile') || '{}');
            const { age, height, weight } = profile;
            
            if (!age || !height || !weight) {
                healthSummary.innerHTML = `
                    <div class="text-center py-8 text-slate-400">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-12 h-12 mx-auto mb-2"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                        <p>Complete your profile to see your health summary</p>
                        <button class="mt-2 text-blue-600 font-medium" data-page="profile">Go to Profile</button>
                    </div>
                `;
                
                
                const profileButton = healthSummary.querySelector('[data-page="profile"]');
                if (profileButton) {
                    profileButton.addEventListener('click', (e) => {
                        e.preventDefault();
                        renderPage('profile');
                        updateNavButtons('profile');
                    });
                }
                
                return;
            }
            
            const bmi = calculateBMI(height, weight);
            const bmiCategory = getBMICategory(bmi);
            
            healthSummary.innerHTML = `
                <div class="space-y-4">
                    <div class="flex justify-between items-center">
                        <span class="text-slate-600">BMI</span>
                        <span class="font-semibold text-slate-800">${bmi}</span>
                    </div>
                    <div class="w-full bg-slate-200 rounded-full h-2">
                        <div class="h-2 rounded-full ${getBMIColor(bmi)}" style="width: ${Math.min(100, (bmi / 40) * 100)}%"></div>
                    </div>
                    <div class="text-xs text-slate-500">${bmiCategory}</div>
                    
                    <div class="grid grid-cols-2 gap-4 pt-2">
                        <div class="text-center p-3 bg-blue-50 rounded-lg">
                            <div class="text-lg font-bold text-blue-700">${age}</div>
                            <div class="text-xs text-blue-600">Age</div>
                        </div>
                        <div class="text-center p-3 bg-green-50 rounded-lg">
                            <div class="text-lg font-bold text-green-700">${height} cm</div>
                            <div class="text-xs text-green-600">Height</div>
                        </div>
                        <div class="text-center p-3 bg-purple-50 rounded-lg">
                            <div class="text-lg font-bold text-purple-700">${weight} kg</div>
                            <div class="text-xs text-purple-600">Weight</div>
                        </div>
                        <div class="text-center p-3 bg-amber-50 rounded-lg">
                            <div class="text-lg font-bold text-amber-700">${getBMIRisk(bmi)}</div>
                            <div class="text-xs text-amber-600">Risk Level</div>
                        </div>
                    </div>
                </div>
            `;
        }

      
        function renderCarePlan() {
            const vaccinesList = document.getElementById('vaccines-list');
            const screeningsList = document.getElementById('screenings-list');
            
            if (vaccinesList) {
                vaccinesList.innerHTML = appState.carePlan.vaccines.map(vaccine => `
                    <div class="p-4 bg-slate-50 rounded-lg border border-slate-200">
                        <div class="flex justify-between items-start mb-1">
                            <h4 class="font-semibold text-slate-800">${vaccine.name}</h4>
                            <span class="text-xs font-medium px-2 py-1 rounded-full capitalize ${getPriorityClass(vaccine.priority)}">${vaccine.priority} priority</span>
                        </div>
                        <p class="text-sm text-slate-600">Due: ${formatDisplayDate(vaccine.dueDate)}</p>
                        <p class="text-xs text-slate-500 mt-2">${vaccine.description}</p>
                    </div>
                `).join('');
            }
            
            if (screeningsList) {
                screeningsList.innerHTML = appState.carePlan.screenings.map(screening => `
                    <div class="p-4 bg-slate-50 rounded-lg border border-slate-200">
                        <div class="flex justify-between items-start mb-1">
                            <h4 class="font-semibold text-slate-800">${screening.name}</h4>
                            <span class="text-xs font-medium px-2 py-1 rounded-full capitalize ${getPriorityClass(screening.priority)}">${screening.priority} priority</span>
                        </div>
                        <p class="text-sm text-slate-600">Due: ${formatDisplayDate(screening.dueDate)}</p>
                        <p class="text-xs text-slate-500 mt-2">${screening.description}</p>
                    </div>
                `).join('');
            }
        }

        
        let currentDate = new Date();
        const renderCalendar = () => {
            const monthYearEl = document.getElementById('month-year');
            const daysEl = document.getElementById('calendar-days');
            const appointmentListEl = document.getElementById('appointment-list');

            if (!monthYearEl || !daysEl || !appointmentListEl) return;
            
            monthYearEl.textContent = currentDate.toLocaleString('default', { month: 'long', year: 'numeric' });
            daysEl.innerHTML = '';
            
           
            const appointmentsForMonth = appState.appointments.filter(appt => {
                const apptDate = new Date(appt.date);
                return apptDate.getFullYear() === currentDate.getFullYear() && 
                       apptDate.getMonth() === currentDate.getMonth();
            });
            
            
            appointmentsForMonth.sort((a, b) => new Date(a.date) - new Date(b.date));
            
            
            if (appointmentsForMonth.length > 0) {
                appointmentListEl.innerHTML = appointmentsForMonth.map(appt => {
                    const apptDate = new Date(appt.date);
                    return `
                        <div class="p-4 bg-white rounded-lg border border-slate-200">
                            <h4 class="font-semibold text-slate-800">${appt.title}</h4>
                            <p class="text-sm text-slate-600">${apptDate.toLocaleDateString()} at ${appt.time || 'All day'}</p>
                            <p class="text-xs text-slate-500 mt-2">${appt.notes || 'No additional notes'}</p>
                            <div class="flex justify-between items-center mt-2">
                                <button class="text-xs text-blue-600 set-reminder" data-id="${appt.id}">Set Reminder</button>
                                <button class="text-xs text-red-600 delete-appointment" data-id="${appt.id}">Delete</button>
                            </div>
                        </div>
                    `;
                }).join('');
                
                
                document.querySelectorAll('.delete-appointment').forEach(button => {
                    button.addEventListener('click', (e) => {
                        const id = e.target.getAttribute('data-id');
                        handleDeleteAppointment(id);
                    });
                });
                
               
                document.querySelectorAll('.set-reminder').forEach(button => {
                    button.addEventListener('click', (e) => {
                        const id = e.target.getAttribute('data-id');
                        handleSetReminder(id);
                    });
                });
            } else {
                appointmentListEl.innerHTML = `
                    <div class="text-center py-8 text-slate-400">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-12 h-12 mx-auto mb-2"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/></svg>
                        <p>No upcoming appointments</p>
                        <button class="mt-2 text-blue-600 font-medium" id="add-first-appointment">Add your first appointment</button>
                    </div>
                `;
                
                
                document.getElementById('add-first-appointment').addEventListener('click', () => {
                    handleAddAppointment();
                });
            }

            
            const firstDayOfMonth = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1).getDay();
            const daysInMonth = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0).getDate();
            const today = new Date();

            
            for (let i = 0; i < firstDayOfMonth; i++) {
                daysEl.innerHTML += `<div class="p-2"></div>`;
            }

           
            for (let day = 1; day <= daysInMonth; day++) {
                const dayEl = document.createElement('div');
                dayEl.textContent = day;
                dayEl.className = 'calendar-day p-2 text-center rounded-lg cursor-pointer';
                
                const currentDay = new Date(currentDate.getFullYear(), currentDate.getMonth(), day);
                const hasAppointment = appointmentsForMonth.some(appt => {
                    const apptDate = new Date(appt.date);
                    return apptDate.getDate() === day;
                });

               
                if (currentDay.getDate() === today.getDate() && 
                    currentDay.getMonth() === today.getMonth() && 
                    currentDay.getFullYear() === today.getFullYear()) {
                    dayEl.classList.add('today');
                } else if (hasAppointment) {
                    dayEl.classList.add('has-appointment');
                }

                dayEl.addEventListener('click', () => handleAddAppointment(day));
                daysEl.appendChild(dayEl);
            }
        };

        const handleAddAppointment = (day) => {
            const title = prompt("Enter appointment title:");
            if (!title) return;
            
            const notes = prompt("Enter notes for this appointment (optional):") || '';
            const time = prompt("Enter time (e.g., 10:00 AM) or leave blank for all day:") || 'All day';
            
            
            let appointmentDate;
            if (day) {
                appointmentDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), day);
            } else {
           
                appointmentDate = new Date();
            }
            
            const newAppointment = {
                id: Date.now().toString(),
                title,
                date: appointmentDate.toISOString().split('T')[0],
                time,
                notes
            };
            
            appState.appointments.push(newAppointment);
            localStorage.setItem('healthAppointments', JSON.stringify(appState.appointments));
            renderCalendar();
            showNotification("Appointment added successfully!", "success");
            
           
            if (confirm("Would you like to set a reminder for this appointment?")) {
                handleSetReminder(newAppointment.id);
            }
        };

        const handleDeleteAppointment = (id) => {
            if (confirm("Are you sure you want to delete this appointment?")) {
                appState.appointments = appState.appointments.filter(appt => appt.id !== id);
                localStorage.setItem('healthAppointments', JSON.stringify(appState.appointments));
                renderCalendar();
                showNotification("Appointment deleted successfully!", "success");
            }
        };

        
        function showNotification(message, type = 'info', duration = 5000) {
            const notificationContainer = document.getElementById('notification-container');
            const notificationId = 'notification-' + Date.now();
            
            const notification = document.createElement('div');
            notification.id = notificationId;
            notification.className = `notification ${type === 'alarm' ? 'notification-alarm alarm-ringing' : 
                                        type === 'success' ? 'notification-success' : 
                                        type === 'warning' ? 'notification-warning' : 
                                        'notification-info'}`;
            
            notification.innerHTML = `
                <div class="p-4">
                    <div class="flex items-start gap-3">
                        <div class="flex-shrink-0 mt-1">
                            ${type === 'alarm' ? 
                                '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>' :
                            type === 'success' ? 
                                '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>' :
                            type === 'warning' ? 
                                '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>' :
                                '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>'
                            }
                        </div>
                        <div class="flex-1">
                            <p class="text-sm font-medium">${message}</p>
                        </div>
                        <button class="flex-shrink-0 close-notification" data-id="${notificationId}">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                        </button>
                    </div>
                </div>
            `;
            
            notificationContainer.appendChild(notification);
            
            
            setTimeout(() => {
                notification.classList.add('show');
            }, 10);
            
          
            notification.querySelector('.close-notification').addEventListener('click', () => {
                closeNotification(notificationId);
            });
            
           
            if (type !== 'alarm') {
                setTimeout(() => {
                    closeNotification(notificationId);
                }, duration);
            }
            
            
            if (type === 'alarm') {
                const newNotification = {
                    id: notificationId,
                    message,
                    type,
                    timestamp: new Date().toLocaleString()
                };
                
                appState.notifications.unshift(newNotification);
                localStorage.setItem('healthNotifications', JSON.stringify(appState.notifications));
                
                
                if (appState.currentPage === 'notifications') {
                    renderNotifications();
                }
            }
            
           
            if (type === 'alarm') {
                playAlarmSound();
            }
        }

        function closeNotification(id) {
            const notification = document.getElementById(id);
            if (notification) {
                notification.classList.remove('show');
                setTimeout(() => {
                    if (notification.parentNode) {
                        notification.parentNode.removeChild(notification);
                    }
                }, 300);
            }
        }

        function playAlarmSound() {
         
            try {
                const audioContext = new (window.AudioContext || window.webkitAudioContext)();
                const oscillator = audioContext.createOscillator();
                const gainNode = audioContext.createGain();
                
                oscillator.connect(gainNode);
                gainNode.connect(audioContext.destination);
                
                oscillator.type = 'sine';
                oscillator.frequency.setValueAtTime(800, audioContext.currentTime);
                oscillator.frequency.setValueAtTime(600, audioContext.currentTime + 0.1);
                oscillator.frequency.setValueAtTime(800, audioContext.currentTime + 0.2);
                
                gainNode.gain.setValueAtTime(0.3, audioContext.currentTime);
                gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.5);
                
                oscillator.start(audioContext.currentTime);
                oscillator.stop(audioContext.currentTime + 0.5);
            } catch (e) {
                console.log("Web Audio API not supported");
            }
        }

        function handleSetReminder(appointmentId) {
            const appointment = appState.appointments.find(appt => appt.id === appointmentId);
            if (!appointment) return;
            
            const reminderTime = prompt(`Set reminder for "${appointment.title}" (in minutes):`, "15");
            if (!reminderTime || isNaN(reminderTime)) return;
            
            const reminderMinutes = parseInt(reminderTime);
            const appointmentDate = new Date(appointment.date);
            
            if (appointment.time && appointment.time !== 'All day') {
                const [time, modifier] = appointment.time.split(' ');
                let [hours, minutes] = time.split(':');
                
                if (modifier === 'PM' && hours !== '12') {
                    hours = parseInt(hours) + 12;
                } else if (modifier === 'AM' && hours === '12') {
                    hours = 0;
                }
                
                appointmentDate.setHours(parseInt(hours), parseInt(minutes), 0, 0);
            } else {
                appointmentDate.setHours(9, 0, 0, 0);
            }
            const reminderDate = new Date(appointmentDate.getTime() - (reminderMinutes * 60 * 1000));
            const now = new Date();
            if (reminderDate > now) {
                const timeUntilReminder = reminderDate.getTime() - now.getTime();
                
                setTimeout(() => {
                    showNotification(
                        `Reminder: ${appointment.title} in ${reminderMinutes} minutes${appointment.time !== 'All day' ? ` at ${appointment.time}` : ''}`,
                        'alarm'
                    );
                }, timeUntilReminder);
                
                showNotification(`Reminder set for "${appointment.title}"`, 'success');
            } else {
                showNotification("Cannot set reminder for past appointments", 'warning');
            }
        }

        function testAlarm() {
            showNotification(
                "This is a test alarm for your health appointment",
                'alarm'
            );
        }

        function renderNotifications() {
            const notificationsList = document.getElementById('notifications-list');
            if (!notificationsList) return;
            
            if (appState.notifications.length > 0) {
                notificationsList.innerHTML = appState.notifications.map(notification => `
                    <div class="p-4 rounded-lg border ${notification.type === 'alarm' ? 'border-red-200 bg-red-50' : 
                                            notification.type === 'success' ? 'border-green-200 bg-green-50' : 
                                            notification.type === 'warning' ? 'border-yellow-200 bg-yellow-50' : 
                                            'border-blue-200 bg-blue-50'}">
                        <div class="flex justify-between items-start">
                            <div class="flex-1">
                                <p class="text-sm ${notification.type === 'alarm' ? 'text-red-800' : 
                                                notification.type === 'success' ? 'text-green-800' : 
                                                notification.type === 'warning' ? 'text-yellow-800' : 
                                                'text-blue-800'}">${notification.message}</p>
                                <p class="text-xs ${notification.type === 'alarm' ? 'text-red-600' : 
                                                notification.type === 'success' ? 'text-green-600' : 
                                                notification.type === 'warning' ? 'text-yellow-600' : 
                                                'text-blue-600'} mt-1">${notification.timestamp}</p>
                            </div>
                            <button class="text-xs ${notification.type === 'alarm' ? 'text-red-600' : 
                                                notification.type === 'success' ? 'text-green-600' : 
                                                notification.type === 'warning' ? 'text-yellow-600' : 
                                                'text-blue-600'} delete-notification ml-2" data-id="${notification.id}">
                                Dismiss
                            </button>
                        </div>
                    </div>
                `).join('');
                document.querySelectorAll('.delete-notification').forEach(button => {
                    button.addEventListener('click', (e) => {
                        const id = e.target.getAttribute('data-id');
                        handleDeleteNotification(id);
                    });
                });
            } else {
                notificationsList.innerHTML = `
                    <div class="text-center py-8 text-slate-400">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-12 h-12 mx-auto mb-2"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg>
                        <p>No notifications yet</p>
                    </div>
                `;
            }
        }

        function handleDeleteNotification(id) {
            appState.notifications = appState.notifications.filter(notification => notification.id !== id);
            localStorage.setItem('healthNotifications', JSON.stringify(appState.notifications));
            renderNotifications();
        }

        function clearAllNotifications() {
            if (appState.notifications.length === 0) return;
            
            if (confirm("Are you sure you want to clear all notifications?")) {
                appState.notifications = [];
                localStorage.setItem('healthNotifications', JSON.stringify(appState.notifications));
                renderNotifications();
                showNotification("All notifications cleared", "success");
            }
        }

        function loadNotificationSettings() {
            const settings = JSON.parse(localStorage.getItem('notificationSettings') || '{}');
            
            if (settings.appointmentReminders !== undefined) {
                document.getElementById('appointment-reminders').checked = settings.appointmentReminders;
            }
            if (settings.medicationReminders !== undefined) {
                document.getElementById('medication-reminders').checked = settings.medicationReminders;
            }
            if (settings.healthTips !== undefined) {
                document.getElementById('health-tips').checked = settings.healthTips;
            }
            if (settings.carePlanUpdates !== undefined) {
                document.getElementById('care-plan-updates').checked = settings.carePlanUpdates;
            }
        }

        function saveNotificationSettings() {
            const settings = {
                appointmentReminders: document.getElementById('appointment-reminders').checked,
                medicationReminders: document.getElementById('medication-reminders').checked,
                healthTips: document.getElementById('health-tips').checked,
                carePlanUpdates: document.getElementById('care-plan-updates').checked
            };
            
            localStorage.setItem('notificationSettings', JSON.stringify(settings));
            showNotification("Notification settings saved", "success");
        }

        // Utility functions
        function calculateBMI(height, weight) {
            return (weight / ((height / 100) * (height / 100))).toFixed(1);
        }

        function getBMICategory(bmi) {
            if (bmi < 18.5) return "Underweight";
            if (bmi < 25) return "Normal weight";
            if (bmi < 30) return "Overweight";
            return "Obese";
        }

        function getBMIColor(bmi) {
            if (bmi < 18.5) return "bg-blue-500";
            if (bmi < 25) return "bg-green-500";
            if (bmi < 30) return "bg-yellow-500";
            return "bg-red-500";
        }

        function getBMIRisk(bmi) {
            if (bmi < 18.5) return "Low";
            if (bmi < 25) return "Normal";
            if (bmi < 30) return "Moderate";
            return "High";
        }

        function getPriorityClass(priority) {
            switch(priority) {
                case 'high': return 'priority-high';
                case 'medium': return 'priority-medium';
                case 'low': return 'priority-low';
                default: return 'priority-low';
            }
        }

        function formatDate(date) {
            return date.toISOString().split('T')[0];
        }

        function formatDisplayDate(dateString) {
            const options = { year: 'numeric', month: 'short', day: 'numeric' };
            return new Date(dateString).toLocaleDateString(undefined, options);
        }

        function updateCarePlanBasedOnProfile() {
            const profile = JSON.parse(localStorage.getItem('healthProfile') || '{}');
            const { age, gender, conditions } = profile;
            
            // Update priorities based on profile data
            if (age && parseInt(age) >= 50) {
                // Increase priority of shingles vaccine for older adults
                const shinglesVaccine = appState.carePlan.vaccines.find(v => v.name.includes("Shingles"));
                if (shinglesVaccine) {
                    shinglesVaccine.priority = "high";
                }
                
                // Increase priority of colorectal screening
                const colorectalScreening = appState.carePlan.screenings.find(s => s.name.includes("Colorectal"));
                if (colorectalScreening) {
                    colorectalScreening.priority = "high";
                }
            }
            
            if (conditions && conditions.length > 0) {
                // Increase priority of flu vaccine for those with chronic conditions
                const fluVaccine = appState.carePlan.vaccines.find(v => v.name.includes("Influenza"));
                if (fluVaccine) {
                    fluVaccine.priority = "high";
                }
                
                // Increase priority of pneumococcal vaccine for those with chronic conditions
                const pneumococcalVaccine = appState.carePlan.vaccines.find(v => v.name.includes("Pneumococcal"));
                if (pneumococcalVaccine) {
                    pneumococcalVaccine.priority = "medium";
                }
            }
            
            // Re-render care plan if we're on that page
            if (appState.currentPage === 'careplan') {
                renderCarePlan();
            }
        }

        // Initialize the application
        const init = () => {
            const navButtons = document.querySelectorAll('.nav-item');
            navButtons.forEach(button => {
                button.addEventListener('click', (e) => {
                    const page = e.currentTarget.getAttribute('data-page');
                    appState.currentPage = page;
                    renderPage(page);
                    updateNavButtons(page);
                });
            });

            document.getElementById('mobile-menu-button').addEventListener('click', () => {
                const sidebar = document.getElementById('sidebar');
                const overlay = document.getElementById('sidebar-overlay');
                sidebar.classList.toggle('sidebar-open');
                overlay.classList.toggle('hidden');
            });

            document.getElementById('sidebar-overlay').addEventListener('click', () => {
                const sidebar = document.getElementById('sidebar');
                const overlay = document.getElementById('sidebar-overlay');
                sidebar.classList.remove('sidebar-open');
                overlay.classList.add('hidden');
            });
            const savedAppointments = localStorage.getItem('healthAppointments');
            if (savedAppointments) {
                appState.appointments = JSON.parse(savedAppointments);
            }
            
            const savedProfile = localStorage.getItem('healthProfile');
            if (savedProfile) {
                appState.profile = JSON.parse(savedProfile);
                updateUserName();
                updateCarePlanBasedOnProfile();
            }
            const savedNotifications = localStorage.getItem('healthNotifications');
            if (savedNotifications) {
                appState.notifications = JSON.parse(savedNotifications);
            }
            renderPage(appState.currentPage);
            updateNavButtons(appState.currentPage);
            setTimeout(() => {
                showNotification("Welcome to HealthPlanner! Complete your profile for personalized recommendations.", "info");
            }, 2000);
        };

        window.onload = init;
    </script>
</body>
</html>