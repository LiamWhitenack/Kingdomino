import copy

class domino:

    '''a domino has two properties: crowns and colors. These are both lists of two which can either be of shape [2,1] or shape [1,2]'''

    def __init__(self, crowns:list, colors:list) -> None:
        self.crowns = crowns
        self.colors = colors
        self.horizontal = True

    def rotate(self) -> None:
        self.horizontal = not self.horizontal
        if self.horizontal:
            self.crowns[0], self.crowns[1] = self.crowns[1], self.crowns[0]
            self.colors[0], self.colors[1] = self.colors[1], self.colors[0]

    def check_within_bounds(self, crowns:list, position:tuple):
        empty_spaces = []
        empty_rows = 0
        empty_columns = 0
        for row in range(5):
            for column in range(5):
                if crowns[row][column] == '':
                    empty_spaces.append(row)
                    empty_spaces.append(column + 5)
        for row in range(5):
            if empty_spaces.count(row) == 5:
                empty_rows += 1
        for column in range(5):
            if empty_spaces.count(column + 5) == 5:
                empty_columns += 1

        if position[0] < 0 - empty_columns or position[1] < 0 - empty_rows:
            raise IndexError('You must place dominos within a 5 by 5 grid')
        if 5 in position:
            raise IndexError('You must place dominos within a 5 by 5 grid')
        if 5 in position:
            raise IndexError('You must place dominos within a 5 by 5 grid')
        if not self.horizontal:
            if 5 in (position[0], position[1] + 1):
                raise IndexError('You must place dominos within a 5 by 5 grid')
        else:
            if 5 in (position[0] + 1, position[1]):
                 raise IndexError('You must place dominos within a 5 by 5 grid')

    def check_has_neighbors(self, crowns:list, position:tuple):

        col = position[0]
        row = position[1]

        neighbors = []

        if not self.horizontal:
            neighbors.append((col, row - 1)) # above
            neighbors.append((col - 1, row)) # left
            neighbors.append((col + 1, row)) # right
            neighbors.append((col - 1, row + 1)) # left bottom
            neighbors.append((col + 1, row + 1)) # right bottom
            neighbors.append((col, row + 2)) # very bottom

        else:
            neighbors.append((col, row - 1)) # above
            neighbors.append((col - 1, row)) # left
            neighbors.append((col + 2, row)) # very right
            neighbors.append((col + 1, row - 1)) # right top
            neighbors.append((col + 1, row + 1)) # right bottom
            neighbors.append((col, row + 1)) # bottom

        delete_list = []
        for pair in neighbors:
            if -1 in pair:
                delete_list.append(pair)
            elif 5 in pair:
                delete_list.append(pair)

        for pair in delete_list:
            neighbors.remove(pair)
        
        for col, row in neighbors:
            if crowns[row][col] != '':
                return
            
        raise IndexError("The domino must be placed orthogonally adjacent to another domino")

    def check_has_same_color_neighbors(self, colors:list, position:tuple):

        col = position[0]
        row = position[1]

        neighbors = []

        neighbors.append((col, row - 1)) # above
        neighbors.append((col - 1, row)) # left
        neighbors.append((col + 1, row)) # right
        neighbors.append((col, row + 1)) # bottom

        for col, row in neighbors:
            if 5 in (col, row) or -1 in (col, row):
                continue
            if colors[row][col] == self.colors[0]:
                return
            if colors[row][col] == 'on_light_grey':
                return
    
        col = position[0] + (1 if self.horizontal else 0)
        row = position[1] + (1 if not self.horizontal else 0)

        neighbors = []

        neighbors.append((col, row - 1)) # above
        neighbors.append((col - 1, row)) # left
        neighbors.append((col + 1, row)) # right
        neighbors.append((col, row + 1)) # bottom

        for col, row in neighbors:
            if 5 in (col, row) or -1 in (col, row):
                continue
            if colors[row][col] == self.colors[1]:
                print(f'neighbor: {row, col}, neighbor color: {colors[row][col]}, part color: {self.colors[0]}, domino section: {1}')
                return
            if colors[row][col] == 'on_light_grey':
                print(f'neighbor: {row, col}, neighbor color: {colors[row][col]}, part color: {self.colors[0]}, domino section: {1}')
                return
            
        raise IndexError("The domino must be placed orthogonally adjacent to another domino of the same color")


class kingdom:

    '''each kingdom has a kingdom (which can be up to 5 by 5) and the ability to pick dominos and place them in the kingdom'''

    def __init__(self) -> None:
        self.kingdom_crowns = [['' for _ in range(5)] for __ in range(5)]
        self.kingdom_colors = [['on_black' for _ in range(5)] for __ in range(5)]
        self.kingdom_crowns[0][0] = '+'
        self.kingdom_colors[0][0] = 'on_light_grey'

    def place_domino(self, domino:domino, position:tuple) -> tuple:
        '''returns the value of a domino if it were to be placed at the 
        given position exppressed as the m, n distance from the top left 
        corner (positions can be negative)'''
        
        kingdom_crowns = copy.deepcopy(self.kingdom_crowns)
        kingdom_colors = copy.deepcopy(self.kingdom_colors)

        m = position[0]
        n = position[1]

        # move the tiles to the right if the kingdom wants to place on the left

        if m < 0:
            for row in range(5):
                if kingdom_crowns[row][4] != '':
                    raise IndexError('Not a valid position!')
                if kingdom_crowns[row][3] != '' and m == -2:
                    raise IndexError('Not a valid position!')
            for row in range(5):
                for col in range(5 + m):
                    kingdom_crowns[row][col - m] = self.kingdom_crowns[row][col]
                    kingdom_colors[row][col - m] = self.kingdom_colors[row][col]
            for row in range(5):
                kingdom_crowns[row][0] = ''
                kingdom_colors[row][0] = 'on_black'
                kingdom_crowns[row][1 if m == -2 else 0] = ''
                kingdom_colors[row][1 if m == -2 else 0] = 'on_black'
            m = 0

        # move the tiles up if the kingdom wants to place above

        if n < 0:
            for col in range(5):
                if kingdom_crowns[4][col] != '':
                    raise IndexError('Not a valid position!')
                if kingdom_crowns[3][col] != '' and n == -2:
                    raise IndexError('Not a valid position!')
            for row in range(5 + n):
                kingdom_crowns[row - n] = self.kingdom_crowns[row]
                kingdom_colors[row - n] = self.kingdom_colors[row]
            kingdom_crowns[0] = ['' for _ in range(5)]
            kingdom_colors[0] = ['on_black' for _ in range(5)]
            kingdom_crowns[1 if n == -2 else 0] = ['' for _ in range(5)]
            kingdom_colors[1 if n == -2 else 0] = ['on_black' for _ in range(5)]
            n = 0

        # place the domino horizontally or horizontally
        if not domino.horizontal:
            kingdom_crowns[n][m] = domino.crowns[0]
            kingdom_crowns[n + 1][m] = domino.crowns[1]
            kingdom_colors[n][m] = domino.colors[0]
            kingdom_colors[n + 1][m] = domino.colors[1]
        else:
            kingdom_crowns[n][m] = domino.crowns[0]
            kingdom_crowns[n][m + 1] = domino.crowns[1]
            kingdom_colors[n][m] = domino.colors[0]
            kingdom_colors[n][m + 1] = domino.colors[1]


        return kingdom_crowns, kingdom_colors
    
    def update_board(self, crowns_n_colors):
        self.kingdom_crowns = crowns_n_colors[0]
        self.kingdom_colors = crowns_n_colors[1]

    def check_valid_kingdom(crowns_n_colors) -> bool:
        kingdom_crowns = crowns_n_colors[0]
        kingdom_colors = crowns_n_colors[1]
