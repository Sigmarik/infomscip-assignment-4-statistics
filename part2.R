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
# 

