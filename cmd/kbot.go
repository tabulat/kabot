/*
Copyright © 2025 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/spf13/cobra"
	telebot "gopkg.in/telebot.v3"
)

var (
	TeleToken = os.Getenv("TELE_TOKEN")
)

// kbotCmd represents the kbot command
var kbotCmd = &cobra.Command{
	Use:     "kbot",
	Aliases: []string{"start", "s", "com"},
	Short:   "Telegram bot for determining time",
	Long: `Allows you to find out the local time.

Usage:
	/start time	- Show local time
	/start hello   	- Get a greeting from the bot`,
	Run: func(cmd *cobra.Command, args []string) {

		fmt.Printf("kbot %s started", appVersion)
		fmt.Println()

		kbot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})

		if err != nil {
			log.Fatalf("Plaese check TELE_TOKEN env variable. %s", err)
			return
		}

		kbot.Handle(telebot.OnText, func(m telebot.Context) error {

			log.Printf("Receive message: %s", m.Text())
			payload := m.Message().Payload

			switch payload {
			case "hello":
				return m.Send(fmt.Sprintf("Hello I'm KBOT %s!", appVersion))
			case "time":
				now := time.Now()
				return m.Send(fmt.Sprintf("%s\n", now.Format("2006-01-02 15:04:05")))
			default:
				return m.Send("Usage: /start hello|time")
			}

		})

		kbot.Start()
	},
}

func init() {
	rootCmd.AddCommand(kbotCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// kbotCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// kbotCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
