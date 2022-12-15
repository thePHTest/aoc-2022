package day1

import "core:container/bit_array"
import "core:fmt"
import "core:math"
import "core:math/big"
import "core:mem"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:text/scanner"
import "core:time"
import "core:unicode/utf8"

day1_input : string = #load("day1.txt")
day2_input : string = #load("day2.txt")
day3_input : string = #load("day3.txt")
day4_input : string = #load("day4.txt")
day5_input : string = #load("day5.txt")
day6_input : string = #load("day6.txt")
day7_input : string = #load("day7.txt")
day7_test_input : string = #load("day7_test.txt")
day8_input : string = #load("day8.txt")
day8_test_input : string = #load("day8_test.txt")
day9_input : string = #load("day9.txt")
day10_input : string = #load("day10.txt")
day10_test_input : string = #load("day10_test.txt")
day11_input : string = #load("day11.txt")
day11_test_input : string = #load("day11_test.txt")
day12_input : string = #load("day12.txt")
day13_input : string = #load("day13.txt")
day13_part2_input : string = #load("day13_part2.txt")
day13_test_input : string = #load("day13_test.txt")
day14_input : string = #load("day14.txt")
day15_input : string = #load("day15.txt")
day15_test_input : string = #load("day15_test.txt")

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

	keys, err := slice.map_keys(chars, context.temp_allocator)
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
		keys, err = slice.map_keys(chars, context.temp_allocator)
	}
	fmt.println(window)
	fmt.println(chars)
	fmt.println(idx+14)
}

day7 :: proc() {
	File :: struct {
		size : int,
		name : string,
	}

	Dir :: struct {
		parent : ^Dir,
		children : map[string]^Dir,
		files : [dynamic]File,
		total_files_size : int,
		total_size : int,
	}

	compute_size :: proc(dir: ^Dir, under_limit_sum : ^int) -> int {
		children_sum := 0
		for k,d in dir.children {
			cs := compute_size(d, under_limit_sum)
			children_sum += cs
		}
		dir.total_size = dir.total_files_size + children_sum
		if dir.total_size <= 100000 {
			(under_limit_sum^) += dir.total_size
		}
		return dir.total_size
	}

	input := day7_input
	root : Dir
	root.files = make([dynamic]File)
	curr_dir := &root

	lines := strings.split(input, "\n")
	lines = lines[:len(lines)-1]
	i := 0
	for i < len(lines) {
		str := lines[i]
		if strings.has_prefix(str, "$ cd") {
			new_dir := strings.cut(str, 5, 0)
			new_dir = strings.trim_space(new_dir)
			if new_dir == "/" {
				curr_dir = &root
			} else if new_dir == ".." {
				curr_dir = curr_dir.parent
			} else {
				curr_dir = curr_dir.children[new_dir]
			}
			i += 1
		} else if strings.has_prefix(str, "$ ls") {
			i += 1
			str = lines[i]
			for !strings.has_prefix(str, "$") {
				if strings.has_prefix(str, "dir") {
					new_dir_str := strings.cut(str, 4, 0)
					new_dir_str = strings.trim_space(new_dir_str)
					new_dir := new(Dir)
					new_dir.parent = curr_dir
					new_dir.files = make([dynamic]File)
					curr_dir.children[new_dir_str] = new_dir
				} else {
					parts := strings.split_multi(str, {" ", "\n"})
					size := strconv.atoi(parts[0])
					filename := parts[1]
					curr_dir.total_files_size += size
					append(&curr_dir.files, File{size, filename})
				}
				i += 1
				if i >= len(lines) do break
				str = lines[i]
			}
		}
	}

	under_limit_sum := 0
	compute_size(&root, &under_limit_sum)
	// Part 1
	fmt.println("Under Limit Sum:", under_limit_sum)

	// Part 2
	update_size := 30000000
	unused_space := 70000000 - root.total_size
	needed_space := update_size - unused_space

	min_size_found := root.total_size
	find_dir(&root, needed_space, &min_size_found)

	find_dir :: proc(dir: ^Dir, needed_space: int, min_size_found: ^int) {
		for k,d in dir.children {
			if d.total_size <= min_size_found^ && d.total_size >= needed_space {
				min_size_found^ = d.total_size
				find_dir(d, needed_space, min_size_found)
			}
		}
	}

	fmt.println("Needed:", needed_space)
	fmt.println("Found:", min_size_found)
}

day8 :: proc() {
	input := day8_input
	lines := strings.split(input, "\n")
	for line in &lines {
		line = strings.trim_space(line)
	}
	lines = lines[: len(lines)-1] // Remove final empty line
	width := len(lines[0])
	height := len(lines)
	trees := make([]int, width*height)
	visible := make([]bool, width*height)
	for line, ridx in lines {
		for r, cidx in line {
			trees[ridx*width + cidx] = strconv.atoi(utf8.runes_to_string({r}, context.temp_allocator))
		}
	}

	// Visbility from left edge
	for ridx in 0..<height {
		max_height := min(int)
		for cidx in 0..<width {
			tree := trees[ridx*width + cidx]
			if tree > max_height {
				visible[ridx*width + cidx] = true
				max_height = tree
			}
		}
	}

	// Visbility from right edge
	for ridx in 0..<height {
		max_height := min(int)
		for cidx in 0..<width {
			tree := trees[ridx*width + width - 1 - cidx]
			if tree > max_height {
				visible[ridx*width + width - 1 - cidx] = true
				max_height = tree
			}
		}
	}

	// Visbility from top edge
	for cidx in 0..<width {
		max_height := min(int)
		for ridx in 0..<height {
			tree := trees[ridx*width + cidx]
			if tree > max_height {
				visible[ridx*width + cidx] = true
				max_height = tree
			}
		}
	}

	// Visbility from bottom edge
	for cidx in 0..<width {
		max_height := min(int)
		for ridx in 0..<height {
			tree := trees[(width-1-ridx)*width + cidx]
			if tree > max_height {
				visible[(width-1-ridx)*width + cidx] = true
				max_height = tree
			}
		}
	}

	count := 0
	for v in visible {
		count += int(v)
	}

	/*for ridx in 0..<width {*/
		/*fmt.println(visible[ridx*width:][:width])*/
	/*}*/
	fmt.println(count)

	score := make([]int, width*height)
	// Part 2
	max_score := min(int)
	for ridx in 0..<height {
		for cidx in 0..<width {
			tree := trees[ridx*width + cidx]
			left_score, right_score, up_score, down_score : int
			// Iterate left
			for left in 1..=cidx {
				left_score += 1
				opt := trees[ridx*width + cidx - left]
				if opt >= tree {
					break
				}
			}
			// Iterate right
			for right in (cidx+1)..<width {
				right_score += 1
				opt := trees[ridx*width + right]
				if opt >= tree {
					break
				}
			}
			// Iterate down
			for down in (ridx+1)..<height {
				down_score += 1
				opt := trees[down*width + cidx]
				if opt >= tree {
					break
				}
			}
			// Iterate up
			for up in 1..=ridx {
				up_score += 1
				opt := trees[(ridx-up)*width + cidx]
				if opt >= tree {
					break
				}
			}
			scenic_score := left_score * right_score * up_score * down_score
			max_score = max(max_score, scenic_score)
			score[ridx*width + cidx] = scenic_score
		}
	}

	/*for ridx in 0..<width {*/
		/*fmt.println(score[ridx*width:][:width])*/
	/*}*/
	fmt.println(max_score)
}

day9_part1 :: proc() {
	input := day9_input
	grid : map[[2]int]bool
	grid[{0,0}] = true

	head : [2]int = {0, 0}
	tail : [2]int = {0, 0}

	adjacent :: proc(a,b : [2]int) -> bool {
		return !(abs(a.x-b.x) > 1 || abs(a.y-b.y) > 1)
	}

	for str in strings.split_iterator(&input, "\n") {
		parts := strings.split_multi(str, {" ", "\n"})
		dir := parts[0]
		amount := strconv.atoi(parts[1])

		switch dir {
		case "U":
			for i in 0..<amount {
				head.y += 1
				if !adjacent(head, tail) {
					tail = {head.x, tail.y + 1}
					grid[tail] = true
				}
			}
		case "D":
			for i in 0..<amount {
				head.y -= 1
				if !adjacent(head, tail) {
					tail = {head.x, tail.y - 1}
					grid[tail] = true
				}
			}
		case "L":
			for i in 0..<amount {
				head.x -= 1
				if !adjacent(head, tail) {
					tail = {tail.x - 1, head.y}
					grid[tail] = true
				}
			}
		case "R":
			for i in 0..<amount {
				head.x += 1
				if !adjacent(head, tail) {
					tail = {tail.x + 1, head.y}
					grid[tail] = true
				}
			}
		case:
			unreachable()
		}
	}
	keys, _ := slice.map_keys(grid)
	fmt.println(len(keys))
}

day9_part2 :: proc() {
	input := day9_input
	grid : map[[2]int]struct{}
	grid[{0,0}] = {}

	head : [2]int
	tails : [9][2]int

	adjacent :: proc(a,b : [2]int) -> bool {
		return !(abs(a.x-b.x) > 1 || abs(a.y-b.y) > 1)
	}

	move :: proc(tail : ^[2]int, head: [2]int) {
		if tail.x == head.x {
			tail.y += int(math.sign(f32(head.y - tail.y)))
		} else if tail.y == head.y {
			tail.x += int(math.sign(f32(head.x - tail.x)))
		} else {
			tail.x += int(math.sign(f32(head.x - tail.x)))
			tail.y += int(math.sign(f32(head.y - tail.y)))
		}
	}

	for str in strings.split_iterator(&input, "\n") {
		parts := strings.split_multi(str, {" ", "\n"})
		dir := parts[0]
		amount := strconv.atoi(parts[1])

		heading : [2]int
		switch dir {
		case "U":
			heading = {0, 1}
		case "D":
			heading = {0, -1}
		case "L":
			heading = {-1, 0}
		case "R":
			heading = {1, 0}
		case:
			unreachable()
		}

		for i in 0..<amount {
			head += heading
			ahead := head
			for t, idx in &tails {
				if !adjacent(ahead, t) {
					move(&t, ahead)
					if idx == 8 {
						grid[t] = {}
					}
				}
				ahead = t
			}
		}
	}
	fmt.println(len(grid))
}

day10 :: proc() {
	input := day10_input
	values := make([dynamic]int)
	cycle_count := 1
	value := 1
	for str in strings.split_iterator(&input, "\n") {
		parts := strings.split(str, " ")
		if len(parts) == 1{
			// noop
			append(&values, value)
			cycle_count += 1
		} else if len(parts) == 2 {
			//addx
			v := strconv.atoi(parts[1])
			append(&values, value)
			append(&values, value)
			value += v
			cycle_count += 2
		}
	}
	twenty := values[19]
	sixty := values[59]
	hundred := values[99]
	hundred_forty := values[139]
	hundred_eighty := values[179]
	two_hundred_twenty := values[219]
	// Part 1
	sum := 20*twenty + 60*sixty + 100*hundred + 140*hundred_forty + hundred_eighty*180 + 220*two_hundred_twenty
	fmt.println(sum)

	// Part 2
	for v, idx in values {
		x_pos := idx % 40
		if x_pos == 0 {
			fmt.println()
		}
		if abs(v - x_pos) <= 1 {
			fmt.print("#")
		} else {
			fmt.print(".")
		}
	}
}

day11 :: proc() {
	monkey0 : [dynamic]u128 = {83, 88, 96, 79, 86, 88, 70}
	monkey1 : [dynamic]u128 = {59, 63, 98, 85, 68, 72}
	monkey2 : [dynamic]u128 = {90, 79, 97, 52, 90, 94, 71, 70}
	monkey3 : [dynamic]u128 = {97, 55, 62}
	monkey4 : [dynamic]u128 = {74, 54, 94, 76}
	monkey5 : [dynamic]u128 = {58}
	monkey6 : [dynamic]u128 = {66, 63}
	monkey7 : [dynamic]u128 = {56, 56, 90, 96, 68}

	monkeys : [8][dynamic]u128 = {monkey0, monkey1, monkey2, monkey3, monkey4, monkey5, monkey6, monkey7}

	throws : [8]u128

	mag :: 11 * 5 * 19 * 13 * 7 * 17 * 2 * 3
	reduce :: proc(a : ^u128) {
		for a^ > mag {
			a^ -= mag
		}
	}

	for round in 0..<10000 {
		fmt.println(round)
		for monkey, idx in &monkeys {
			switch idx {
			case 0:
				for item in &monkey {
					reduce(&item)
					new := item * 5
					/*new = new / 3*/
					if new % 11 == 0 {
						append(&monkeys[2], new)
					} else {
						append(&monkeys[3], new)
					}
				}
			case 1:
				for item in &monkey {
					reduce(&item)
					new := item * 11 
					/*new = new / 3*/
					if new % 5 == 0 {
						append(&monkeys[4], new)
					} else {
						append(&monkeys[0], new)
					}
				}
			case 2:
				for item in &monkey {
					reduce(&item)
					new := item + 2 
					/*new = new / 3*/
					if new % 19 == 0 {
						append(&monkeys[5], new)
					} else {
						append(&monkeys[6], new)
					}
				}
			case 3:
				for item in &monkey {
					reduce(&item)
					new := item + 5 
					/*new = new / 3*/
					if new % 13 == 0 {
						append(&monkeys[2], new)
					} else {
						append(&monkeys[6], new)
					}
				}
			case 4:
				for item in &monkey {
					reduce(&item)
					new := item * item 
					/*new = new / 3*/
					if new % 7 == 0 {
						append(&monkeys[0], new)
					} else {
						append(&monkeys[3], new)
					}
				}
			case 5:
				for item in &monkey {
					reduce(&item)
					new := item + 4 
					/*new = new / 3*/
					if new % 17 == 0 {
						append(&monkeys[7], new)
					} else {
						append(&monkeys[1], new)
					}
				}
			case 6:
				for item in &monkey {
					reduce(&item)
					new := item + 6 
					/*new = new / 3*/
					if new % 2 == 0 {
						append(&monkeys[7], new)
					} else {
						append(&monkeys[5], new)
					}
				}
			case 7:
				for item in &monkey {
					reduce(&item)
					new := item + 7 
					/*new = new / 3*/
					if new % 3 == 0 {
						append(&monkeys[4], new)
					} else {
						append(&monkeys[1], new)
					}
				}
			case:
				unreachable()
			}
			throws[idx] += u128(len(monkey))
			clear(&monkey)
		}
	}

	slice.reverse_sort(throws[:])
	fmt.println(throws)
	fmt.println(throws[0] * throws[1])
}

day11_test :: proc() {
	monkey0 : [dynamic]u128 = {79, 98}
	monkey1 : [dynamic]u128 = {54, 65, 75, 74}
	monkey2 : [dynamic]u128 = {79, 60, 97}
	monkey3 : [dynamic]u128 = {74}

	monkeys : [4][dynamic]u128 = {monkey0, monkey1, monkey2, monkey3}

	throws : [4]u128
	fmt.println(monkeys)

	mag :: 19 * 23 * 13 * 17
	reduce :: proc(a : ^u128) {
		for a^ > mag {
			a^ -= mag
		}
	}

	for round in 0..<10000 {
		for monkey, idx in &monkeys {
			switch idx {
			case 0:
				for item in &monkey {
					reduce(&item)
					new := item * 19 
					/*new = new / 3*/
					if new % 23 == 0 {
						append(&monkeys[2], new)
					} else {
						append(&monkeys[3], new)
					}
				}
			case 1:
				for item in &monkey {
					reduce(&item)
					new := item + 6 
					/*new = new / 3*/
					if new % 19 == 0 {
						append(&monkeys[2], new)
					} else {
						append(&monkeys[0], new)
					}
				}
			case 2:
				for item in &monkey {
					reduce(&item)
					new := item * item 
					/*new = new / 3*/
					if new % 13 == 0 {
						append(&monkeys[1], new)
					} else {
						append(&monkeys[3], new)
					}
				}
			case 3:
				for item in &monkey {
					reduce(&item)
					new := item + 3 
					/*new = new / 3*/
					if new % 17 == 0 {
						append(&monkeys[0], new)
					} else {
						append(&monkeys[1], new)
					}
				}
			case:
				unreachable()
			}
			throws[idx] += u128(len(monkey))
			clear(&monkey)
		}
	}

	slice.reverse_sort(throws[:])
	fmt.println(throws)
	fmt.println(throws[0] * throws[1])
}

day12 :: proc() {
	input := day12_input
	lines := strings.split(input, "\n")
	lines = lines[:len(lines) - 1] // remove extra empty line
	// remove newline characters
	for line in &lines {
		line = strings.trim_space(line)
	}
	width := len(lines[0])
	height := len(lines)

	start : [2]int
	end : [2]int
	grid := make([]int, width*height)
	for ridx in 0..<height {
		for cidx in 0 ..<width {
			if lines[ridx][cidx] == 'S' {
				start = {cidx, ridx}
				grid[ridx*width + cidx] = 'a' - 'a'
			} else if lines[ridx][cidx] == 'E' {
				end = {cidx, ridx}
				grid[ridx*width + cidx] = 'z' - 'a'
			} else {
				grid[ridx*width + cidx] = int(lines[ridx][cidx]) - 'a'
			}
		}
	}

	dist :: proc(a,b : [2]int) -> int {
		return (abs(b.x - a.x) + abs(b.y - a.y))
	}

	get_path :: proc(came_from : map[[2]int][2]int, current: [2]int) -> [dynamic][2]int {
		path := make([dynamic][2]int)
		curr := [2]int{current.x, current.y}
		contains := current in came_from
		for contains {
			curr = came_from[curr]
			contains = curr in came_from
			append(&path, current)
		}
		return path 
	}

	min_steps := max(int)
	for oridx in 0..<height {
		for ocidx in 0..<width {
			if !(grid[oridx*width + ocidx] == 0) do continue
			start = {ocidx, oridx}
			/*fmt.println(start)*/

			open_set := make([dynamic][2]int)
			append(&open_set, end)
			came_from := make(map[[2]int][2]int)

			g_score := make(map[[2]int]int)
			g_score[end] = 0

			f_score := make(map[[2]int]int)
			f_score[end] = dist(end, start)

			find_path : for len(open_set) > 0 {
				current : [2]int
				min_f := max(int)
				min_idx : int
				for v, idx in open_set {
					score := f_score[v] or_else max(int)
					if score < min_f {
						min_f = score
						current = v
						min_idx = idx
					}
				}

				if current == start {
					path := get_path(came_from, current)
					if len(path) < min_steps {
						min_steps = len(path)
					}
					break find_path
				}
				unordered_remove(&open_set, min_idx)
				
				current_val := grid[current.y * width + current.x]
				for i in -1..=1 {
					ridx := current.y + i
					if ridx < 0 || ridx >= height do continue
					for j in -1..=1 {
						if i == 0 && j == 0 do continue
						if (abs(i) + abs(j)) > 1 do continue
						cidx := current.x + j
						if cidx < 0 || cidx >= width do continue
						neighbor := [2]int{cidx, ridx}

						tentative_g := g_score[current] + 1
						if (grid[ridx*width + cidx] - current_val < -1) {
							// not an option. continue
							continue
						}
						neighbor_g := g_score[neighbor] or_else max(int)

						if tentative_g < neighbor_g {
							came_from[neighbor] = current
							g_score[neighbor] = tentative_g
							f_score[neighbor] = tentative_g + dist(neighbor, start)
							if !slice.contains(open_set[:], neighbor) {
								append(&open_set, neighbor)
							}
						}
					}
				}
			}
		}
	}
	fmt.println(min_steps)
}

day13 :: proc() {
	List :: struct {
		values : [dynamic]Data,
	}

	Data :: union {
		^List,
		int,
	}

	input := day13_input
	lines := strings.split(input, "\n")
	lines = lines[:len(lines)-1]

	packets : [dynamic]^List
	for packet_str in &lines {
		packet_str = strings.trim_space(packet_str)
		if packet_str == "" do continue
		/*fmt.println(packet_str)*/
		s : scanner.Scanner
		scanner.init(&s, packet_str)

		packet : ^List = new(List)
		append(&packets, packet)

		lists_stack := make([dynamic]^List)
		curr_list : ^List = packet
		for r := scanner.scan(&s); r != scanner.EOF; r = scanner.scan(&s) {
			switch r {
			case '[':
				new_list := new(List)
				append(&curr_list.values, new_list)
				append(&lists_stack, curr_list)
				curr_list = new_list
			case ',':
				// Do nothing
			case ']':
				curr_list = pop(&lists_stack)
			case scanner.Int:
				val := strconv.atoi(scanner.token_text(&s))
				append(&curr_list.values, val)
			case:
				fmt.println("invalid token", r)
				unreachable()
			}
		}
	}

	print_packet :: proc(packet : ^List) {
		fmt.print("[")
		for v in packet.values {
			switch t in v {
			case ^List:
				print_packet(t)
			case int:
				fmt.print(t, ",")
			}
		}
		fmt.print("]")
	}

	for p in packets {
		fmt.println()
		print_packet(p)
		fmt.println()
	}

	Result :: enum {
		Correct,
		Incorrect,
		Undecided,
	}

	compare :: proc(a, b: ^List) -> Result {
		if len(a.values) == 0 && len(b.values) == 0 {
			return .Undecided
		} else if len(a.values) == 0 {
			return .Correct
		} else if len(b.values) == 0 {
			return .Incorrect
		}
		lval := a.values[0]
		rval := b.values[0]
		switch t in lval {
		case ^List:
			switch t2 in rval {
			case ^List:
				switch compare(t, t2) {
				case .Undecided:
					//advance
					ordered_remove(&a.values, 0)
					ordered_remove(&b.values, 0)
					return compare(a, b)
				case .Correct:
					return .Correct
				case .Incorrect:
					return .Incorrect
				}
			case int:
				new_list := new(List)
				append(&new_list.values, t2)
				b.values[0] = new_list
				return compare(a, b)
			}
		case int:
			switch t2 in rval {
			case ^List:
				new_list := new(List)
				append(&new_list.values, t)
				a.values[0] = new_list
				return compare(a, b)
			case int:
				if t == t2 {
					//advance
					ordered_remove(&a.values, 0)
					ordered_remove(&b.values, 0)
					return compare(a, b)
				} else {
					if t < t2 {
						return .Correct
					} else {
						return .Incorrect
					}
				}
			}
		}
		unreachable()
	}

	sum := 0
	pair_index := 1
	for i := 0; i < len(packets) - 2; i += 2 {
		left := packets[i]
		right := packets[i + 1]

		result := compare(left,right)
		fmt.println(result)
		if result == .Correct {
			sum += pair_index
		}
		pair_index += 1
	}
	fmt.println(sum)
}

day13_part2 :: proc() {
	List :: struct {
		values : [dynamic]Data,
	}

	Data :: union {
		^List,
		int,
	}

	input := day13_part2_input
	lines := strings.split(input, "\n")
	lines = lines[:len(lines)-1]

	packets : [dynamic]^List
	for packet_str in &lines {
		packet_str = strings.trim_space(packet_str)
		if packet_str == "" do continue
		/*fmt.println(packet_str)*/
		s : scanner.Scanner
		scanner.init(&s, packet_str)

		packet : ^List = new(List)
		append(&packets, packet)

		lists_stack := make([dynamic]^List)
		curr_list : ^List = packet
		for r := scanner.scan(&s); r != scanner.EOF; r = scanner.scan(&s) {
			switch r {
			case '[':
				new_list := new(List)
				append(&curr_list.values, new_list)
				append(&lists_stack, curr_list)
				curr_list = new_list
			case ',':
				// Do nothing
			case ']':
				curr_list = pop(&lists_stack)
			case scanner.Int:
				val := strconv.atoi(scanner.token_text(&s))
				append(&curr_list.values, val)
			case:
				fmt.println("invalid token", r)
				unreachable()
			}
		}
	}

	print_packet :: proc(packet : ^List) {
		fmt.print("[")
		for v in packet.values {
			switch t in v {
			case ^List:
				print_packet(t)
			case int:
				fmt.print(t, ",")
			}
		}
		fmt.print("]")
	}

	/*for p in packets {*/
		/*fmt.println()*/
		/*print_packet(p)*/
		/*fmt.println()*/
	/*}*/

	Result :: enum {
		Correct,
		Incorrect,
		Undecided,
	}

	compare :: proc(a, b: ^List) -> Result {
		if len(a.values) == 0 && len(b.values) == 0 {
			return .Undecided
		} else if len(a.values) == 0 {
			return .Correct
		} else if len(b.values) == 0 {
			return .Incorrect
		}
		lval := a.values[0]
		rval := b.values[0]
		switch t in lval {
		case ^List:
			switch t2 in rval {
			case ^List:
				switch compare(t, t2) {
				case .Undecided:
					//advance
					ordered_remove(&a.values, 0)
					ordered_remove(&b.values, 0)
					return compare(a, b)
				case .Correct:
					return .Correct
				case .Incorrect:
					return .Incorrect
				}
			case int:
				new_list := new(List)
				append(&new_list.values, t2)
				b.values[0] = new_list
				return compare(a, b)
			}
		case int:
			switch t2 in rval {
			case ^List:
				new_list := new(List)
				append(&new_list.values, t)
				a.values[0] = new_list
				return compare(a, b)
			case int:
				if t == t2 {
					//advance
					ordered_remove(&a.values, 0)
					ordered_remove(&b.values, 0)
					return compare(a, b)
				} else {
					if t < t2 {
						return .Correct
					} else {
						return .Incorrect
					}
				}
			}
		}
		unreachable()
	}

	copy_list :: proc(a: ^List) -> ^List {
		the_copy := new(List)
		for v in a.values {
			switch t in v {
			case ^List:
				append(&the_copy.values, copy_list(t))
			case int:
				append(&the_copy.values, t)
			}
		}
		return the_copy
	}

	sort_cmp_proc :: proc(a,b : ^List) -> bool {
		a_copy := copy_list(a)
		b_copy := copy_list(b)
		defer free(a_copy)
		defer free(b_copy)
		if compare(a_copy,b_copy) == .Correct {
			return true
		}
		return false
	}
	slice.sort_by(packets[:], sort_cmp_proc)


	reduce :: proc(b: ^strings.Builder, l: ^List) {
		for v in l.values {
			switch t in v {
			case ^List:
				strings.write_string(b, "[")
				reduce(b, t)
				strings.write_string(b, "]")
			case int:
				strings.write_int(b, t)
				strings.write_string(b, ",")
			}
		}
	}

	two_idx : int
	six_idx : int
	for p,idx in packets {
		b := strings.builder_make()
		reduce(&b, p)
		str := strings.to_string(b)
		if str == "[[2,]]" {
			fmt.println("found 2 packet")
			two_idx = idx
		} else if str == "[[6,]]" {
			fmt.println("found 6 packet")
			six_idx = idx
		}
	}
	two_idx += 1
	six_idx += 1
	fmt.println(two_idx * six_idx)
}

day14 :: proc() {
	input := day14_input
	DIM :: 1000
	grid := new([DIM][DIM]bool)
	defer free(grid)

	lines := strings.split(input, "\n")
	lines = lines[:len(lines)-1]

	max_y := min(int)
	for line in &lines {
		line = strings.trim_space(line)
		coords := strings.split(line, " -> ")
		start_coord, end_coord : [2]int
		for coord, idx in coords {
			parts := strings.split(coord, ",")
			if idx == 0 {
				start_coord = {strconv.atoi(parts[0]), strconv.atoi(parts[1])}
				continue
			}

			end_coord = {strconv.atoi(parts[0]), strconv.atoi(parts[1])}
			if start_coord.x == end_coord.x {
				start_y := min(start_coord.y, end_coord.y)
				end_y := max(start_coord.y, end_coord.y)
				for y in start_y ..= end_y {
					max_y = max(max_y, y) 
					grid[y][start_coord.x] = true
				}
			} else if start_coord.y == end_coord.y {
				start_x := min(start_coord.x, end_coord.x)
				end_x := max(start_coord.x, end_coord.x)
				max_y = max(max_y, start_coord.y) 
				for x in start_x ..= end_x {
					grid[start_coord.y][x] = true
				}
			} else {
				panic("Invalid coordinates")
			}

			start_coord = end_coord
		}
	}

	floor := max_y + 2
	for x in 0..<DIM {
		grid[floor][x] = true
	}

	// Fill with sand
	sand_count := 0
	fill : for {
		single : for {
			curr_pos := [2]int{500, 0}
			for {
				// Uncomment these 3 lines for a part 1 answer
				/*if curr_pos.y > max_y {*/
					/*break fill*/
				/*}*/
				if !grid[curr_pos.y + 1][curr_pos.x] {
					curr_pos += {0, 1}
				} else if !grid[curr_pos.y + 1][curr_pos.x - 1] {
					curr_pos += {-1, 1}
				} else if !grid[curr_pos.y + 1][curr_pos.x + 1] {
					curr_pos += {1, 1}
				} else {
					grid[curr_pos.y][curr_pos.x] = true
					sand_count += 1
					if curr_pos == {500, 0} {
						break fill
					}
					break single
				}
			}
		}
	}
	/*fmt.println(sand_count)*/
}

day15 :: proc() {
	input := day15_input
	sensors := make([dynamic][2]int)
	beacons := make([dynamic][2]int)
	distances := make([dynamic]int)

	OCCUPANCE_ROW :: 2000000
	/*OCCUPANCE_ROW :: 10*/
	empty_set := make(map[[2]int]struct{})

	dist :: proc(a,b : [2]int) -> int {
		return abs(b.x - a.x) + abs(b.y - a.y)
	}

	for str in strings.split_lines_iterator(&input) {
		parts := strings.split_multi(str, {"Sensor at x=", ", y=", ": closest beacon is at x="})
		sensor : [2]int = {strconv.atoi(parts[1]), strconv.atoi(parts[2])}
		beacon : [2]int = {strconv.atoi(parts[3]), strconv.atoi(parts[4])}
		d := dist(sensor, beacon)
		append(&sensors, sensor)
		append(&beacons, beacon)
		append(&distances, d)
	}

	beacon_min : [2]int = {0, 0}
	beacon_max : [2]int = {4000000, 4000000}


	using bit_array
	fmt.println("before make")
	/*unoccupied_set := make(map[[2]int]struct{})*/
	occupied_set := create(1 + beacon_max.x*beacon_max.y)
	fmt.println("after make")
	/*for x in beacon_min.x..=beacon_max.x {*/
		/*fmt.println(x)*/
		/*for y in beacon_min.y..=beacon_max.y {*/
			/*set(&unoccupied_set, x*y)*/
		/*}*/
	/*}*/
	fmt.println("after fill")

	for s, idx in &sensors {
		max_dist := distances[idx]
		for y in beacon_min.y..=beacon_max.y {
			fmt.println(y)
			y_dist := abs(s.y - y)
			diff := max_dist - y_dist
			if diff < 0 {
				continue
			}
			x_len := diff*2 + 1

			for x in -(x_len/2)..=(x_len/2) {
				/*delete_key(&unoccupied_set, [2]int{x,y})*/
				if x >= 0 {
					set(occupied_set, y*beacon_max.y + x)
				} else {
					//skip
				}
			}
		}
	}

	for b, idx in &beacons {
		/*delete_key(&unoccupied_set, b)*/
		set(occupied_set, b.y*beacon_max.y + b.x)
	}
	
	/*fmt.println(unoccupied_set)*/

	it := make_iterator(occupied_set)
	for index in iterate_by_unset(&it) {
		fmt.println("found distress")
		y := index / beacon_max.y
		x := index - (y*beacon_max.y)
		freq := 4000000*x + y
		fmt.println(freq)
	}



	/*for k,v in unoccupied_set {*/
		/*fmt.println("found distress")*/
		/*freq := 4000000*k.x + k.y*/
		/*fmt.println(freq)*/
	/*}*/

	/*// find*/
	/*for x in beacon_min.x..=beacon_max.x {*/
			/*fmt.println("x", x)*/
		/*for y in beacon_min.y..=beacon_max.y {*/
			/*pos := [2]int{x,y}*/
			/*if !(pos in empty_set) {*/
				/*fmt.println("found distress")*/
				/*freq := 4000000*x + y*/
				/*fmt.println(freq)*/
			/*}*/
		/*}*/
	/*}*/
}

day15_part2 :: proc() {
	input := day15_input
	
	Data_Point :: struct {
		sensor : [2]int,
		beacon : [2]int,
		distance : int,

		min_x, max_x, min_y, max_y : int,
	}
	data_points := make([dynamic]Data_Point)
	sensors := make([dynamic][2]int)
	beacons := make([dynamic][2]int)
	distances := make([dynamic]int)

	empty_set := make(map[[2]int]struct{})

	dist :: proc(a,b : [2]int) -> int {
		return abs(b.x - a.x) + abs(b.y - a.y)
	}

	for str in strings.split_lines_iterator(&input) {
		parts := strings.split_multi(str, {"Sensor at x=", ", y=", ": closest beacon is at x="})
		sensor : [2]int = {strconv.atoi(parts[1]), strconv.atoi(parts[2])}
		beacon : [2]int = {strconv.atoi(parts[3]), strconv.atoi(parts[4])}
		d := dist(sensor, beacon)
		append(&sensors, sensor)
		append(&beacons, beacon)
		append(&distances, d)
		min_x := sensor.x - d
		max_x := sensor.x + d
		min_y := sensor.y - d
		max_y := sensor.y + d
		append(&data_points, Data_Point{sensor, beacon, d, min_x, max_x, min_y, max_y})
	}

	cmp :: proc(a,b: Data_Point) -> bool {
		return a.min_x < b.min_x
	}
	data := data_points[:]
	slice.sort_by(data, cmp)

	ranges := make([dynamic][2]int, len(data_points)*2)
	/*DIM :: 4000000*/
	DIM :: 4000000
	for idx in 0..<DIM {
		clear(&ranges)

		// gather ranges
		for d, data_idx in data_points {
			// this sensor has no effect
			if idx < d.min_y || idx > d.max_y {
				continue
			}

			// calculate the row coverage
			y_diff := abs(d.sensor.y - idx)
			if y_diff > d.distance {
				/*fmt.println("shouldnt be here?")*/
				continue
			}
			x_half := d.distance - y_diff

			min_x := d.sensor.x - x_half
			max_x := d.sensor.x + x_half
			ranges[data_idx] = {min_x, max_x}
			append(&ranges, [2]int{min_x, max_x})
			if d.beacon.y == idx {
				append(&ranges, [2]int{d.beacon.x, d.beacon.x})
			}
		}

		range_cmp :: proc(a,b: [2]int) -> bool {
			return a.x < b.x
		}
		slice.sort_by(ranges[:], range_cmp)
		
		max_possible_x := ranges[0].y + 1
		for range in ranges[1:] {
			if !(range.x <= max_possible_x) {
				// found the gap
				/*fmt.println("~~~~~~~~~~~found distress~~~~")*/
				y := idx
				freq := u128(4000000)*u128(max_possible_x) + u128(y)
				/*fmt.println(max_possible_x, y)*/
				fmt.println(freq)
				break
			} else {
				max_possible_x = max(max_possible_x, range.y+1)
			}
		}
	}
}

main :: proc() {
	s2 := time.now()
	/*for i in 0..<1000 {*/
	day15_part2()
	/*}*/
	e2 := time.now()
	fmt.println("time:", time.duration_seconds(time.diff(s2, e2)))
}
