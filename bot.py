import os
import asyncio

from aiogram import Bot, Dispatcher
from aiogram.types import Message
from aiogram.filters import CommandStart

from openai import OpenAI


TOKEN = os.getenv("8276868929:AAFeeNegPgzRzSXWbvjsYi37SpSSo7mBee8")

client = OpenAI(
    api_key=os.getenv("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"),
    base_url="https://openrouter.ai/api/v1"
)

bot = Bot(token=TOKEN)
dp = Dispatcher()


async def ask_ai(prompt: str):
    response = await asyncio.to_thread(
        client.chat.completions.create,
        model="openai/gpt-4o-mini",
        messages=[
            {"role": "system", "content": "Ты AI для музыки и креатива."},
            {"role": "user", "content": prompt}
        ]
    )
    return response.choices[0].message.content


@dp.message(CommandStart())
async def start(message: Message):
    await message.answer("🎵 Бот работает")


@dp.message()
async def chat(message: Message):

    if not message.text:
        return

    text = message.text.strip()

    if text.startswith("/hook"):
        idea = text.replace("/hook", "")
        result = await ask_ai("Хук: " + idea)
        await message.answer(result)
        return

    if text.startswith("/lyrics"):
        idea = text.replace("/lyrics", "")
        result = await ask_ai("Лирика: " + idea)
        await message.answer(result)
        return

    result = await ask_ai(text)
    await message.answer(result)


async def main():
    print("BOT STARTED")
    await bot.delete_webhook(drop_pending_updates=True)
    await dp.start_polling(bot)


if __name__ == "__main__":
    asyncio.run(main())
