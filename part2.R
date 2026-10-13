new_data <- aggregate(Response ~ PID + Condition,
                      data = subset(Responses, Measure == "Body Ownership"),
                      FUN = median)

f_val <- friedman.test(Response ~ Condition | PID, data = new_data)
print(f_val)


data_a <- new_data$Response[new_data$Condition == "Alien Hand"]
data_b <- new_data$Response[new_data$Condition == "Matched Hand"]
data_c <- new_data$Response[new_data$Condition == "Mismatched Hand"]

test_ab <- wilcox.test(data_a, data_b, paired = TRUE)
test_ac <- wilcox.test(data_a, data_c, paired = TRUE)
test_bc <- wilcox.test(data_b, data_c, paired = TRUE)
p_ab <- test_ab$p.value
p_ac <- test_ac$p.value
p_bc <- test_bc$p.value
cat("Wilcox tests:\n")
cat("Alien + Matched p: ", p_ab, "and V: ", test_ab$statistic, "\n")
cat("Alien + Mismatched p: ", p_ac, "and V: ", test_ac$statistic, "\n")
cat("Mismatched + Matched p: ", p_bc, "and V: ", test_bc$statistic, "\n")

