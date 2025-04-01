from transformers import pipeline

def sentiment(text:str):
    pipe = pipeline("text-classification", model="cardiffnlp/twitter-roberta-base-sentiment-latest") # 150 MB
    return pipe(text)

if __name__ == "__main__":
    ticket_text = "I'm having an issue with the Bose Sound Link. Please assist. This problem started occurring after the recent software update. I haven't made any other changes to the device."
    print(sentiment(ticket_text))

    #[{'label': 'negative', 'score': 0.8280922770500183}]
