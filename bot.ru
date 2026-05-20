from aiogram import Bot, Dispatcher
from aiogram.types import Message
from aiogram.filters import CommandStart

import asyncio

from openai import OpenAI


# ======================================
# TOKENS
# ======================================

TOKEN = "8276868929:AAE1FgoaIpBG9Z8-CyePlJk_4TTz1BvNBIs"


client = OpenAI(
    api_key="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",
    base_url="https://openrouter.ai/api/v1"
)


# ======================================
# BOT
# ======================================

bot = Bot(token=TOKEN)

dp = Dispatcher()


# ======================================
# AI
# ======================================

async def ask_ai(prompt):

    response = client.chat.completions.create(
        model="openai/gpt-4o-mini",
        messages=[
            {
                "role": "system",
                "content": """
Ты AI для атмосферной музыки,
deep house,
лирики,
хуков,
Suno style
и Shorts.
"""
            },
            {
                "role": "user",
                "content": prompt
            }
        ]
    )

    return response.choices[0].message.content


# ======================================
# START
# ======================================

@dp.message(CommandStart())
async def start(message: Message):

    text = """
🎵 Я рядом

Команды:

/hook тема
/lyrics тема
/style тема
/shorts тема
/caption тема
"""

    await message.answer(text)


# ======================================
# MAIN CHAT
# ======================================

@dp.message()
async def chat(message: Message):

    text = message.text


    # HOOK
    if text.startswith("/hook"):

        idea = text.replace("/hook", "")

        prompt = f"""
Придумай атмосферный музыкальный хук.

Тема:
{idea}
"""

        result = await ask_ai(prompt)

        await message.answer(result)

        return


    # LYRICS
    if text.startswith("/lyrics"):

        idea = text.replace("/lyrics", "")

        prompt = f"""
Напиши атмосферную лирику.

Тема:
{idea}
"""

        result = await ask_ai(prompt)

        await message.answer(result)

        return


    # STYLE
    if text.startswith("/style"):

        idea = text.replace("/style", "")

        prompt = f"""
Напиши Suno style prompt.

Тема:
{idea}
"""

        result = await ask_ai(prompt)

        await message.answer(result)

        return


    # SHORTS
    if text.startswith("/shorts"):

        idea = text.replace("/shorts", "")

        prompt = f"""
Придумай идею Shorts/Reels.

Тема:
{idea}
"""

        result = await ask_ai(prompt)

        await message.answer(result)

        return


    # CAPTION
    if text.startswith("/caption"):

        idea = text.replace("/caption", "")

        prompt = f"""
Напиши YouTube caption.

Тема:
{idea}
"""

        result = await ask_ai(prompt)

        await message.answer(result)

        return


    # DEFAULT CHAT
    result = await ask_ai(text)

    await message.answer(result)


# ======================================
# MAIN
# ======================================

async def main():

    print("BOT STARTED")

    await dp.start_polling(bot)


asyncio.run(main())