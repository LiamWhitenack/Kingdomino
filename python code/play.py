import keyboard
from classes import kingdom, domino
from termcolor import colored

def main():
    while True:
        print('how many players would you like to play with?')
        players_num = input()
        if players_num in [2,3,4]:
            break
        print('please input a number from 2 to 4')

def print_kingdom(kingdom_crowns:list,kingdom_colors:list):
    '''This relatively complex function will print the kingdom out while ignoring all of the empty parts of the kingdom'''
    empty_spaces = []
    empty_rows = []
    empty_columns = []
    for row in range(5):
        for column in range(5):
            if kingdom_crowns[row][column] == '':
                empty_spaces.append(row)
                empty_spaces.append(column + 5)
    for row in range(5):
        if empty_spaces.count(row) == 5:
            empty_rows.append(row)
    for column in range(5):
        if empty_spaces.count(column + 5) == 5:
            empty_columns.append(column + 5)
    for row in range(5 - len(empty_rows)):
        cols = 5 - len(empty_columns)
        print(first_n_values(kingdom_crowns[row], kingdom_colors[row], cols))


def first_n_values(vals:list, colors:list, n:int) -> str:
    result = ''
    for i in range(n):
        result += colored((' ' + (str(vals[i]) if str(vals[i]) else ' ') + ' ').replace('[]', '[ ]'), color='black', on_color=colors[i]) + '  '
    return result.replace('[]', '[ ]')

    

