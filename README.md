#  Ai_Veille — Scraping des actualités IA
## Technologiy used

- [Scrapy]  (https://scrapy.org/)
- [Playwright]  (https://playwright.dev/)
- [Supabase]  (https://supabase.com/)
- [Google Gemini API]  (https://ai.google.dev/)
- [Python 3.13+]  (https://www.python.org/)
- [dotenv]  (https://pypi.org/project/python-dotenv/)

## main structure

Ai_Veille/ 
├── main.py # Manual scraper launch
├── auto_runner.py #Automated launch
├── ia_scraper/ #Scrapy project 
  ├── spiders/articles.py # Main Spider
  └── settings.py # Configs Scrapy & Playwright
├── supabase_db/ # Supabase connection
   ├── db_services.py │
   ├── summarizer.py #Summaries via Gemini 
   └── client.py ├── .env # Environment variables (not versioned)
├── requirements.txt └── README.md


### 1.  Clone the project
-cd ai_veille

### 2. Install dependencies

-python -m venv .venv
-source .venv/Scripts/activate    # Windows
# ou
source .venv/bin/activate        # Linux/macOS

### 3.Install required packages

-pip install -r requirements.txt

### 4. Configure Supabase (premiere fois)

- Cree un projet sur [supabase.com](https://supabase.com) (gratuit)
- Dans **SQL Editor**, colle le contenu de `supabase_setup.sql` et execute-le :
  ca cree les tables `sources` et `articles` + 3 sources de depart

### 5. Configure the environment

Copie `.env.example` en `.env` puis remplis tes cles :

-SUPABASE_URL=...   (Dashboard > Project Settings > API)
-SUPABASE_KEY=...
-GEMINI_API_KEY=... (https://aistudio.google.com/apikey)

### 6. Run the scraper

python main.py

# Ou en automatique, toutes les 2 heures :
python auto_runner.py


