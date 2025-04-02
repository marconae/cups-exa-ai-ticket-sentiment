from transformers import pipeline
import time

PIPE = pipeline("text-classification", model="cardiffnlp/twitter-roberta-base-sentiment-latest") # 150 MB

def sentiment(text:str):
    return PIPE(text)

if __name__ == "__main__":
    ticket_text = "I'm having an issue with the Bose Sound Link. Please assist. This problem started occurring after the recent software update. I haven't made any other changes to the device."

    start_time = time.perf_counter()
    sentiment1 = sentiment(ticket_text)
    end_time = time.perf_counter()

    print(f"Sentiment 1: {sentiment1}")
    print(f"Execution Time: {end_time - start_time}")

    start_time = time.perf_counter()
    sentiment2 = sentiment(ticket_text)
    end_time = time.perf_counter()

    print(f"Sentiment 2: {sentiment2}")
    print(f"Execution Time: {end_time - start_time}")


