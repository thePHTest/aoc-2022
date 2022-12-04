package day1

import "core:slice"
import "core:strconv"
import "core:strings"
import "core:fmt"

day1_input : string = #load("day1.txt")
day2_input : string = #load("day2.txt")
day3_input : string = #load("day3.txt")

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
	for str in strings.split_iterator(&input, "\n") {
		score_pt2 += rps_map_2[str]
	}
	fmt.println(score_pt2)
}

Ruck :: struct {
	left: string,
	right: string,
	priority : u8,
}

day3 :: proc() {
	rucks := make([dynamic]Ruck)
	// Part 1
	input := strings.clone(day3_input)
	for str in strings.split_iterator(&input, "\n") {
		ruck := new(Ruck)
		ruck.left = str[:(len(str)/2)]
		ruck.right = str[len(str)/2:]

		for r in ruck.left {
			if strings.contains_rune(ruck.right, r) != -1 {
				if u8(r) > 96 {
					ruck.priority = u8(r) - 96
				} else {
					ruck.priority = u8(r) - 38
				}
				fmt.println(r, ruck.priority)
			}
		}
		append(&rucks, ruck^)
	}
	sum := 0
	for r in rucks {
		sum += int(r.priority)
	}
	fmt.println("Sum:", sum)

	// Part 2
	priorities := make([dynamic]u8)
	lines := strings.split(day3_input, "\n")
	lines = lines[0:len(lines) - 1] // Remove extra line at end
	str, str2, str3 : string
	ok : bool
	for idx : int = 0; idx < len(lines) - 2; idx+=3 {
		str = lines[idx]
		str2 = lines[idx + 1]
		str3 = lines[idx + 2]
		for r in str {
			if strings.contains_rune(str2, r) != -1 && strings.contains_rune(str3, r) != -1 {
				priority : u8
				if u8(r) > 96 {
					priority = u8(r) - 96
				} else {
					priority = u8(r) - 38
				}
				append(&priorities, priority)
				break
			}
		}
	}
	sum2 := 0
	for p in priorities {
		sum2 += int(p)
	}
	fmt.println("Sum 2:", sum2)
}

day4 :: proc() {
	// Part 1 count
	contains_count := 0
	// Part 2 count
	overlaps_count := 0
	for str in strings.split_iterator(&day4_input, "\n") {
		parts := strings.split_multi(str, {",", "-"})
		left_min, _ := strconv.parse_int(parts[0])
		left_max, _ := strconv.parse_int(parts[1])
		right_min, _ := strconv.parse_int(parts[2])
		right_max, _ := strconv.parse_int(parts[3])
		contains_count += int((left_min <= right_min && left_max >= right_max) || (right_min <= left_min && right_max >= left_max))
		overlaps_count += int((left_max >= right_min && left_max <= right_max) || (right_max >= left_min && right_max <= left_max))
	}
	fmt.println("Contains count:", contains_count)
	fmt.println("Overlaps count:", overlaps_count)
}

day4_input : string = #load("day4.txt")
day4_v2 :: proc() {
	contains_count := 0
	overlaps_count := 0
	for str in strings.split_iterator(&day4_input, "\n") {
		parts := strings.split_multi(str, {",", "-"})
		vals := slice.mapper(parts, strconv.atoi)
		contains_count += int((vals[0] <= vals[2] && vals[1] >= vals[3]) || (vals[2] <= vals[0] && vals[3] >= vals[1]))
		overlaps_count += int((vals[1] >= vals[2] && vals[1] <= vals[3]) || (vals[3] >= vals[0] && vals[3] <= vals[1]))
	}
	fmt.println("Contains count:", contains_count)
	fmt.println("Overlaps count:", overlaps_count)
}

main :: proc() {
	day4_v2()
}
