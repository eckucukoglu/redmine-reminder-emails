resources :projects do
  resources :reminder_entries do
    post '', :to => 'reminder_entries#send_now', as: 'send'
  end
end
