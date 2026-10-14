new_data <- aggregate(Response ~ PID + Condition,
                      data = subset(Responses, Measure == "Body Ownership"),
                      FUN = median)

combined_data <- merge(new_data, Demographics[, c("PID", "VR Experience")], by = "PID")
matched_data <- subset(combined_data, Condition == "Matched Hand")
mismatched_data <- subset(combined_data, Condition == "Mismatched Hand")
alien_data <- subset(combined_data, Condition == "Alien Hand")


vr_exp_matched <- as.numeric(factor(matched_data$`VR Experience`, levels = c("5-9 hours", "10-49 hours", "50-99 hours", "100+ hours")))
vr_exp_mismatched <- as.numeric(factor(mismatched_data$`VR Experience`, levels = c("5-9 hours", "10-49 hours", "50-99 hours", "100+ hours")))
vr_exp_alien <- as.numeric(factor(alien_data$`VR Experience`, levels = c("5-9 hours", "10-49 hours", "50-99 hours", "100+ hours")))


spearman_match <- cor.test(matched_data$`Response`, vr_exp_matched ,method = "spearman", exact = FALSE)
spearman_mismatch <- cor.test(mismatched_data$`Response`, vr_exp_mismatched ,method = "spearman", exact = FALSE)
spearman_alien <- cor.test(alien_data$`Response`, vr_exp_alien ,method = "spearman", exact = FALSE)

print(spearman_match)
print(spearman_mismatch)
print(spearman_alien)

p <- ggplot(counts_df, aes(x = VRExperience, y = Response, fill = Frequency)) +
  geom_tile(color = "white", linewidth = 0.5) + # Creates clean grid lines
  geom_text(aes(label = Frequency), color = "black", size = 6) + # Overlays exact counts
  scale_fill_gradient(low = "#e0f3db", high = "#43a2ca") + # Light green/blue to deep blue gradient
  labs(
    title = "Correlation Heatmap: VR Experience vs Body Ownership",
    subtitle = "Condition: Matched Hand (Frequencies per cell)",
    x = "VR Experience Category",
    y = "Body Ownership",
    fill = "Count"
  ) +
  theme_minimal(base_size = 19)

print(p)

single_condition_data <- subset(combined_data, Condition == "Mismatched Hand")

single_condition_data$`VR Experience` <- factor(
  single_condition_data$`VR Experience`,
  levels = c("5-9 hours", "10-49 hours", "50-99 hours", "100+ hours")
)

p2 <- ggplot(counts_df, aes(x = VRExperience, y = Response, fill = Frequency)) +
  geom_tile(color = "white", linewidth = 0.5) + # Creates clean grid lines
  geom_text(aes(label = Frequency), color = "black", size = 6) + # Overlays exact counts
  scale_fill_gradient(low = "#e0f3db", high = "#43a2ca") + # Light green/blue to deep blue gradient
  labs(
    title = "Correlation Heatmap: VR Experience vs Body Ownership",
    subtitle = "Condition: Mismatched Hand (Frequencies per cell)",
    x = "VR Experience Category",
    y = "Body Ownership",
    fill = "Count"
  ) +
  theme_minimal(base_size = 19)

print(p2)
single_condition_data <- subset(combined_data, Condition == "Alien Hand")

single_condition_data$`VR Experience` <- factor(
  single_condition_data$`VR Experience`,
  levels = c("5-9 hours", "10-49 hours", "50-99 hours", "100+ hours")
)

p3 <- ggplot(counts_df, aes(x = VRExperience, y = Response, fill = Frequency)) +
  geom_tile(color = "white", linewidth = 0.5) + # Creates clean grid lines
  geom_text(aes(label = Frequency), color = "black", size = 6) + # Overlays exact counts
  scale_fill_gradient(low = "#e0f3db", high = "#43a2ca") + # Light green/blue to deep blue gradient
  labs(
    title = "Correlation Heatmap: VR Experience vs Body Ownership",
    subtitle = "Condition: Alien Hand (Frequencies per cell)",
    x = "VR Experience Category",
    y = "Body Ownership",
    fill = "Count"
  ) +
  theme_minimal(base_size = 19)
print(p3)
