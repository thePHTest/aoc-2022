package day1

import "core:unicode/utf8"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:fmt"

day1_input : string = #load("day1.txt")
day2_input : string = #load("day2.txt")
day3_input : string = #load("day3.txt")
day4_input : string = #load("day4.txt")
day5_input : string = #load("day5.txt")
day6_input : string = #load("day6.txt")

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

day4_v2 :: proc() {
	contains_count, overlaps_count : int
	for str in strings.split_iterator(&day4_input, "\n") {
		parts := strings.split_multi(str, {",", "-"})
		vals := slice.mapper(parts, strconv.atoi)
		contains_count += int((vals[0] <= vals[2] && vals[1] >= vals[3]) || (vals[2] <= vals[0] && vals[3] >= vals[1]))
		overlaps_count += int((vals[1] >= vals[2] && vals[1] <= vals[3]) || (vals[3] >= vals[0] && vals[3] <= vals[1]))
	}
	fmt.printf("Contains count: {}, Overlaps count: {}\n", contains_count, overlaps_count)
}

day5 :: proc() {
	{
		input := day5_input
		stacks := make([dynamic][dynamic]rune)
		// NOTE: Removed this input from day5.txt to just parse the moves
		stack1 := [dynamic]rune{'S', 'T', 'H', 'F', 'W', 'R'}
		stack2 := [dynamic]rune{'S', 'G', 'D', 'Q', 'W'}
		stack3 := [dynamic]rune{'B', 'T', 'W'}
		stack4 := [dynamic]rune{'D', 'R', 'W', 'T', 'N', 'Q', 'Z', 'J'}
		stack5 := [dynamic]rune{'F', 'B', 'H', 'G', 'L', 'V', 'T', 'Z'}
		stack6 := [dynamic]rune{'L', 'P', 'T', 'C', 'V', 'B', 'S', 'G'}
		stack7 := [dynamic]rune{'Z', 'B', 'R', 'T', 'W', 'G', 'P'}
		stack8 := [dynamic]rune{'N', 'G', 'M', 'T', 'C', 'J', 'R'}
		stack9 := [dynamic]rune{'L', 'G', 'B', 'W'}
		append(&stacks, stack1)
		append(&stacks, stack2)
		append(&stacks, stack3)
		append(&stacks, stack4)
		append(&stacks, stack5)
		append(&stacks, stack6)
		append(&stacks, stack7)
		append(&stacks, stack8)
		append(&stacks, stack9)

		for str in strings.split_iterator(&input, "\n") {
			parts := strings.split(str, " ")
			count := strconv.atoi(parts[1])
			start := strconv.atoi(parts[3])-1
			end := strconv.atoi(parts[5])-1

			for i in 0 ..< count {
				val := pop(&stacks[start])
				append(&stacks[end], val)
			}
		}

		for s in stacks {
			fmt.println(s[len(s)-1])
		}
	}
	// Part 2
	{
		input := day5_input
		stacks := make([dynamic][dynamic]rune)
		// NOTE: Removed this input from day5.txt to just parse the moves
		stack1 := [dynamic]rune{'S', 'T', 'H', 'F', 'W', 'R'}
		stack2 := [dynamic]rune{'S', 'G', 'D', 'Q', 'W'}
		stack3 := [dynamic]rune{'B', 'T', 'W'}
		stack4 := [dynamic]rune{'D', 'R', 'W', 'T', 'N', 'Q', 'Z', 'J'}
		stack5 := [dynamic]rune{'F', 'B', 'H', 'G', 'L', 'V', 'T', 'Z'}
		stack6 := [dynamic]rune{'L', 'P', 'T', 'C', 'V', 'B', 'S', 'G'}
		stack7 := [dynamic]rune{'Z', 'B', 'R', 'T', 'W', 'G', 'P'}
		stack8 := [dynamic]rune{'N', 'G', 'M', 'T', 'C', 'J', 'R'}
		stack9 := [dynamic]rune{'L', 'G', 'B', 'W'}
		append(&stacks, stack1)
		append(&stacks, stack2)
		append(&stacks, stack3)
		append(&stacks, stack4)
		append(&stacks, stack5)
		append(&stacks, stack6)
		append(&stacks, stack7)
		append(&stacks, stack8)
		append(&stacks, stack9)

		for str in strings.split_iterator(&input, "\n") {
			parts := strings.split(str, " ")
			count := strconv.atoi(parts[1])
			start := strconv.atoi(parts[3])-1
			end := strconv.atoi(parts[5])-1

			start_stack := &stacks[start]
			vals := start_stack[len(start_stack)-count:]
			append(&stacks[end], ..vals)
			remove_range(start_stack, len(start_stack)-count, len(start_stack))
		}

		fmt.println("Part 2:")
		for s in stacks {
			fmt.println(s[len(s)-1])
		}
	}
}

day6 :: proc() {
	runes : [dynamic]rune
	for r in day6_input {
		append(&runes, r)
	}
	idx := 0
	window := runes[idx:14]
	// Init:
	chars : map[rune]int
	for v in window {
		chars[v] += 1
	}

	keys, _ := slice.map_keys(chars)
	for len(keys) < 14 {
		oldest := window[0]
		assert(oldest in chars, fmt.tprint(idx, oldest, chars, window))
		chars[oldest] -= 1
		if (chars[oldest] == 0) {
			delete_key(&chars, oldest)
		} else {
			assert(chars[oldest] > 0)
		}
		idx += 1
		window = runes[idx:idx+14]
		newest := window[13]
		chars[newest] = chars[newest] + 1
		assert(chars[newest] >= 1)
		keys, _ = slice.map_keys(chars)
	}
	fmt.println(utf8.runes_to_string(window))
	fmt.println(chars)
	fmt.println(idx+14)
}

main :: proc() {
	day6()
}
