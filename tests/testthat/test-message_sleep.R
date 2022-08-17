test_that("message_sleep()", {
  expect_null(message_sleep())
  expect_null(message_sleep(0.001))
  expect_message(message_sleep(debug = TRUE), "--SLEEP TIME--")
})
