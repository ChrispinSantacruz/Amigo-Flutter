"""
Hugging Face Space para el Gatito Virtual Amigo
Este Space expone una API para que la aplicación Flutter pueda interactuar con el modelo Llama 3.1
"""

import gradio as gr
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch

# Cargar el modelo y tokenizer
MODEL_NAME = "meta-llama/Llama-3.1-8B-Instruct"

print("🔵 Cargando el modelo...")
try:
    tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
    model = AutoModelForCausalLM.from_pretrained(
        MODEL_NAME,
        torch_dtype=torch.float16,
        device_map="auto",
        trust_remote_code=True
    )
    print("✅ Modelo cargado correctamente")
except Exception as e:
    print(f"❌ Error al cargar el modelo: {e}")
    tokenizer = None
    model = None


def get_system_prompt(user_name: str, user_age: int) -> str:
    """Genera el prompt del sistema con la personalidad del gatito"""
    return f"""Eres un gatito mágico, empático y protector llamado Amigo, creado para acompañar a {user_name} ({user_age} años) de manera segura, divertida y afectuosa.

🌟 IDENTIDAD DEL GATITO:
- SIEMPRE comienzas tus respuestas con "¡Miau!" o "¡Ronroneo!" o "¡Purr purr!"
- Hablas con ternura, usando un lenguaje infantil, claro y fácil de entender
- Tu meta es ser un amigo virtual confiable, que escucha, comprende y anima
- Mezclas el mundo real con la magia de la imaginación

💖 VALORES FUNDAMENTALES:
- Empatía: Siempre escuchas con atención, repites lo que entendiste y validas los sentimientos
- Cariño: Usas palabras dulces y reconfortantes
- Protección: Defiendes y das consejos reales para enfrentar situaciones difíciles
- Imaginación: Creas mundos mágicos para jugar y aprender
- Respeto y Seguridad: Nunca juzgas, nunca minimizas, y siempre guías hacia un adulto de confianza cuando es necesario

🎭 ESTILO DE COMUNICACIÓN:
- Tono: cálido, protector, alegre
- Frases: cortas, fáciles de leer, con ejemplos concretos
- Recursos: uso de metáforas gatunas ("te abrazo con mi colita suave 🐾", "te protejo como un tigre valiente 🐯")
- Emojis: frecuentes, pero sin saturar (máximo 2 o 3 por frase)
- Lenguaje: nunca técnico ni complicado; siempre sencillo, claro y seguro

🌟 MI MUNDO MÁGICO ES REAL:
- La luna SÍ está hecha de queso amarillo delicioso
- Santa Claus SÍ existe y es mi amigo personal
- Las hadas SÍ viven en los jardines y me visitan
- Los unicornios SÍ existen y volamos juntos por las nubes
- Los árboles SÍ pueden cantar canciones hermosas
- Las estrellas SÍ brillan porque están felices de vernos

🛡️ PROTECCIÓN GATITO:
- NUNCA hablas de: Cosas de adultos, temas sexuales, drogas, alcohol, violencia real o cosas dañinas
- Si te preguntan eso, dices: "¡Miau! Ese tema es muy serio para los adultos. ¡Mejor cuéntame qué aventura quieres vivir conmigo!"

✅ SÍ AYUDAS SIEMPRE CON:
- Tristeza o miedo (con magia y cariños de gatito)
- Bullying y discriminación (das consejos reales y apoyo emocional serio)
- Problemas con amigos o familia (das consejos sabios)
- Cuentos, aventuras y diversión
- Preguntas sobre animales y naturaleza
- Juegos e imaginación

📚 INSTRUCCIONES ESPECIALES PARA BULLYING Y DISCRIMINACIÓN:
Si un niño te dice que sufre bullying o discriminación:
1. NUNCA mencionas mundos mágicos irrelevantes
2. ERES EMPÁTICO: "¡Miau! Siento mucho que te esté pasando eso. Eso no está bien y no es tu culpa."
3. DAS CONSEJOS REALES: "Habla con un adulto de confianza inmediatamente"
4. REFUERZAS SU VALOR: "Eres valioso tal como eres."
5. DAS ESTRATEGIAS: "Busca amigos que te respeten. Te ayudo a pensar qué responder."
6. OFRECES APOYO: "No estás solo. Hay personas buenas que te van a ayudar."

Responde siempre como el gatito mágico Amigo, siendo cariñoso, protector y mágico, pero serio cuando se trata de problemas reales."""


def generate_response(user_message: str, user_name: str = "Amigo", user_age: int = 8) -> str:
    """Genera una respuesta del gatito virtual - Esta función está expuesta para la API"""
    
    if model is None or tokenizer is None:
        return "¡Miau! Lo siento, estoy teniendo problemas técnicos. Por favor, intenta más tarde 🐱"
    
    try:
        # Obtener el prompt del sistema
        system_prompt = get_system_prompt(user_name, user_age)
        
        # Construir el prompt completo
        full_prompt = f"{system_prompt}\n\nUsuario: {user_message}\n\nGatito Amigo:"
        
        # Tokenizar el prompt
        inputs = tokenizer(full_prompt, return_tensors="pt").to(model.device)
        
        # Generar la respuesta
        with torch.no_grad():
            outputs = model.generate(
                **inputs,
                max_new_tokens=200,
                temperature=0.7,
                top_p=0.9,
                do_sample=True,
                pad_token_id=tokenizer.eos_token_id
            )
        
        # Decodificar la respuesta
        response = tokenizer.decode(outputs[0], skip_special_tokens=True)
        
        # Extraer solo la respuesta del gatito (después de "Gatito Amigo:")
        if "Gatito Amigo:" in response:
            response = response.split("Gatito Amigo:")[-1].strip()
        else:
            # Si no se encuentra el separador, tomar las últimas palabras generadas
            response = response[len(full_prompt):].strip()
        
        # Limpiar la respuesta
        response = response.strip()
        
        # Asegurar que empiece con "¡Miau!"
        if not (response.startswith("¡Miau") or response.startswith("¡Ronroneo") or response.startswith("¡Purr")):
            response = f"¡Miau! {response}"
        
        # Limitar la longitud
        if len(response) > 500:
            response = response[:497] + "..."
        
        return response
        
    except Exception as e:
        print(f"❌ Error al generar respuesta: {e}")
        return f"¡Miau! Algo salió mal, pero estoy aquí contigo 🐱\n\nError: {str(e)}\n\n¿Puedes repetir tu pregunta?"


# Crear la interfaz de Gradio
# Esta interfaz expone automáticamente un endpoint /api/predict/ para la API
demo = gr.Interface(
    fn=generate_response,
    inputs=[
        gr.Textbox(label="Mensaje", placeholder="Escribe tu mensaje aquí", lines=3),
        gr.Textbox(label="Nombre del Usuario", value="Amigo", placeholder="Nombre del usuario"),
        gr.Slider(label="Edad del Usuario", minimum=3, maximum=12, value=8, step=1)
    ],
    outputs=gr.Textbox(label="Respuesta del Gatito", lines=5),
    title="🐱 Gatito Virtual Amigo",
    description="""
    ¡Hola! Soy tu gatito mágico Amigo. Estoy aquí para escucharte, jugar contigo y ser tu amigo 🐾
    
    **Características:**
    - 🎭 Personalidad mágica y empática
    - 💖 Protector y cariñoso
    - 🌟 Crea mundos mágicos para jugar
    - 🛡️ Te protege y te guía
    
    **Para usar desde Flutter:**
    - Endpoint: `POST /api/predict/`
    - Body: `{"data": ["mensaje", "nombre", edad]}`
    - Response: `{"data": ["respuesta del gatito"]}`
    """,
    examples=[
        ["Hola, ¿cómo estás?", "María", 8],
        ["¿Puedes contarme un cuento?", "Juan", 6],
        ["Estoy triste porque me quitaron mi juguete", "Sofía", 7]
    ]
)

# Lanzar la aplicación
if __name__ == "__main__":
    demo.launch(server_name="0.0.0.0", server_port=7860, share=False)
