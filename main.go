package main

import (
	"bufio"
	"fmt"
	"html/template"
	"os"
	"regexp"
)

type dataSeries struct {
	Data template.JS
}

//go:generate go-bindata -o hdrhistogram.go ./hdrhistogram.template

func main() {

	fi, err := os.Stdin.Stat()
	if err != nil {
		panic(err)
	}
	if fi.Mode()&os.ModeNamedPipe != 0 {
		str := ""
		scanner := bufio.NewScanner(os.Stdin)
		for scanner.Scan() {
			str += scanner.Text() + "\n"
		}
		var re = regexp.MustCompile(`(?ms)^(\s{7}Value.*)^---`)
		if len(re.FindStringIndex(str)) > 0 {
			var s string
			s = re.FindStringSubmatch(str)[1]
			ds := dataSeries{
				Data: template.JS(s),
			}

			asset, err := Asset("hdrhistogram.template")
			t := template.New("hdrHistogram template") // Create a template.
			// // Parse template file.
			t, _ = t.Parse(string(asset))

			err = t.Execute(os.Stdout, ds)

			if err != nil {
				fmt.Println(err)
				return
			}
		}
	} else {
		fmt.Println("wrk-report usage:\n  $ wrk -t2 -c5 -d3s http://myService | wrk-report")
	}
}
