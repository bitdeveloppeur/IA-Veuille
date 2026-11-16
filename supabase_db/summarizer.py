import os
import time

from dotenv import load_dotenv
from google import genai

load_dotenv()

# Modele configurable via .env (par defaut : gemini-2.5-flash)
MODEL = os.getenv("GEMINI_MODEL", "gemini-2.5-flash")

# Client cree paresseusement pour ne pas planter a l'import si la cle manque
_client = None


def _get_client():
    global _client
    if _client is None:
        _client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))
    return _client


def summarize_text(text: str, max_tokens: int = 200) -> str:
    if not text or len(text.strip()) < 30:
        return "Texte insuffisant pour un resume."

    prompt = (
        "Tu es un assistant de veille technologique. "
        "Resume le contenu suivant en francais, de facon concise "
        "(entre 5 et 10 phrases), en gardant les informations essentielles :\n\n"
        f"{text}"
    )

    try:
        # Attendre entre les requetes pour ne pas depasser le quota
        time.sleep(4)
        response = _get_client().models.generate_content(
            model=MODEL,
            contents=prompt,
        )
        print(" resume:", response.text[:100], "...")
        return response.text.strip()
    except Exception as e:
        # Gestion explicite des erreurs de quota (429)
        err_text = str(e)
        if "429" in err_text:
            time.sleep(15)
            try:
                response = _get_client().models.generate_content(
                    model=MODEL,
                    contents=prompt,
                )
                print("Resume (2e tentative)) :", response.text[:100], "...")
                return response.text.strip()
            except Exception as e2:
                print("Echec de nouveau :", e2)
                return "Resume indisponible"
        print(" Erreur Gemini :", e)
        return "Resume indisponible"
