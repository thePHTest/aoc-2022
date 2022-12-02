package day1

import "core:slice"
import "core:strconv"
import "core:strings"
import "core:fmt"

day1_input : string = #load("day1.txt")
day2_input : string = #load("day2.txt")

day1 :: proc() {
	elf : int
	totals := make([dynamic]int)

	for str in strings.split_iterator(&day1_input, "\n") {
		if strings.trim_space(str) == "" {
			append(&totals, elf)
			elf = 0
		} else {
			val, _ := strconv.parse_int(str)
			elf += val
		}
	}
	append(&totals, elf)

	// Part 1
	fmt.println(slice.max(totals[:]))

	// Part 2
	slice.reverse_sort(totals[:])
	fmt.println(totals[0] + totals[1] + totals[2])
}

rps_map_1 : map[string]int = {
	"A X"= 4,
	"A Y" = 8,
	"A Z" = 3,
	"B X"= 1,
	"B Y" = 5,
	"B Z" = 9,
	"C X"= 7,
	"C Y" = 2,
	"C Z" = 6,
}

rps_map_2 : map[string]int = {
	"A X"= 3,
	"A Y" = 4,
	"A Z" = 8,
	"B X"= 1,
	"B Y" = 5,
	"B Z" = 9,
	"C X"= 2,
	"C Y" = 6,
	"C Z" = 7,
}

day2 :: proc() {
	score_pt1 := 0
	input := strings.clone(day2_input)
	for str in strings.split_iterator(&input, "\n") {
		score_pt1 += rps_map_1[str]
	}
	fmt.println(score_pt1)

	score_pt2 := 0
	for str in strings.split_iterator(&day2_input, "\n") {
		score_pt2 += rps_map_2[str]
	}
	fmt.println(score_pt2)
}

main :: proc() {
	day2()
}
