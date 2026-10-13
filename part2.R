new_data <- aggregate(Response ~ PID + Condition,
                      data = subset(Responses, Measure == "Body Ownership"),
                      FUN = median)

library(ggplot2)
combined_data <- merge(new_data, Demographics[, c("PID", "VR Experience")], by = "PID")
#print(unique(combined_data$Condition))
matched_data <- subset(combined_data, Condition == "Matched Hand")
mismatched_data <- subset(combined_data, Condition == "Mismatched Hand")
alien_data <- subset(combined_data, Condition == "Alien Hand")

vr_exp_matched <- as.numeric(factor(matched_data$`VR Experience`, levels = c("5-9 hours", "10-49 hours", "50-99 hours", "100+ hours")))
vr_exp_mismatched <- as.numeric(factor(mismatched_data$`VR Experience`, levels = c("5-9 hours", "10-49 hours", "50-99 hours", "100+ hours")))
vr_exp_alien <- as.numeric(factor(alien_data$`VR Experience`, levels = c("5-9 hours", "10-49 hours", "50-99 hours", "100+ hours")))


library(ggplot2)
combined_data <- merge(new_data, Demographics[, c("PID", "VR Experience")], by = "PID")
#print(unique(combined_data$Condition))
single_condition_data <- subset(combined_data, Condition == "Matched Hand")

single_condition_data$`VR Experience` <- factor(
  single_condition_data$`VR Experience`,
  levels = c("5-9 hours", "10-49 hours", "50-99 hours", "100+ hours")
)

counts_table <- table(single_condition_data$`VR Experience`, single_condition_data$Response)
counts_df <- as.data.frame(counts_table)
colnames(counts_df) <- c("VRExperience", "Response", "Frequency")

p <- ggplot(counts_df, aes(x = VRExperience, y = Response, fill = Frequency)) +
  geom_tile(color = "white", linewidth = 0.5) + # Creates clean grid lines
  geom_text(aes(label = Frequency), color = "black", size = 4) + # Overlays exact counts
  scale_fill_gradient(low = "#e0f3db", high = "#43a2ca") + # Light green/blue to deep blue gradient
  labs(
    title = "Correlation Heatmap: VR Experience vs Body Ownership",
    subtitle = "Condition: Alien Hand (Frequencies per cell)",
    x = "VR Experience Category",
    y = "Body Ownership",
    fill = "Count"
  ) +
  theme_minimal()

print(p)

spearman_match <- cor(matched_data$`Response`, vr_exp ,method = "spearman")
spearman_mismatch <- cor(mismatched_data$`Response`, vr_exp ,method = "spearman")
spearman_alien <- cor(alien_data$`Response`, vr_exp ,method = "spearman")

cat("match: ", spearman_match, "\n")
cat("mismatched: ", spearman_mismatch, "\n")
cat("alien: ", spearman_alien, "\n")
