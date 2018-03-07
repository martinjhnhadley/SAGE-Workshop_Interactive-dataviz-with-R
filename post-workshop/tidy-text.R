library("tidyverse")
library("tidytext")

flatland <- readLines("data/flatland_Edwin-Abbott.txt")

flatland_df <- data_frame(linenumber = 1:length(flatland), text = flatland)

flatland_df %>%
  unnest_tokens(word, text) %>%
  count(word, sort = TRUE)

data("stop_words")

flatland_df_nonstops <- flatland_df %>%
  unnest_tokens(word, text) %>%
  add_count(word, sort = TRUE) %>%
  anti_join(stop_words)

flatland_sentiment <- flatland_df_nonstops %>%
  inner_join(get_sentiments("bing"), by = "word") %>% 
  distinct() %>%
  spread(sentiment, n, fill = 0) %>% 
  mutate(sentiment = positive - negative) %>%
  group_by(linenumber) %>%
  mutate(line.sentiment = sum(sentiment))

flatland_sentiment %>%
  filter(linenumber <= 1000) %>%
  ggplot(aes(linenumber, line.sentiment)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  xlab("line number") +
  ylab("Totalled sentiment of line") +
  ggtitle("Sentiment analysis of Flatland by Edwin Abbott")
