############
## COLORS ##
############

DEF_COLOR	=	\033[0;39m
GRAY		=	\033[0;90m
RED			=	\033[0;91m
GREEN		=	\033[0;92m
YELLOW		=	\033[0;93m
BLUE		=	\033[0;94m
MAGENTA		=	\033[0;95m
CYAN		=	\033[0;96m
WHITE		=	\033[0;97m

#################
## COMPILATION ##
#################

NAME	=	minishell
CC		=	gcc
CFLAGS	=	-Wall -Wextra -Werror
DFLAGS	=	-MMD -MP
FFLAGS	=	-fsanitize=address
IFLAGS	=	-Iinclude/
LFLAGS	=	-L.local/lib -lreadline
DEBUG	=	-g3
FLAGS	=	$(CFLAGS) $(DFLAGS) $(IFLAGS)
#FLAGS	+=	$(FFLAGS)
FLAGS	+=	$(DEBUG)

#################
## DIRECTORIES ##
#################

BLD_DIR	=	build/
EXA_DIR	=	examples/
EXT_DIR	=	external/
XTR_DIR	=	extras/
INC_DIR	=	include/
LIB_DIR	=	libs/
SRC_DIR	=	src/
TES_DIR	=	tests/

#############
## SOURCES ##
#############

SRC_FILES	=	minishell \
				ast/ast \
				execution/exec \
				execution/exec_and \
				execution/exec_or \
				execution/exec_pipe \
				execution/exec_redir \
				lexer/lexer \
				parser/parser \
				parser/parse_cmd \
				parser/parse_pipe \
				parser/parse_redir
TES_FILES	=	test_lexer

########################
## INTERMEDIARY FILES ##
########################

SRC		=	$(addprefix $(SRC_DIR), $(addsuffix .c, $(SRC_FILES)))
OBJ		=	$(addprefix $(BLD_DIR), $(addsuffix .o, $(SRC_FILES)))
TES		=	$(addprefix $(TES_DIR), $(addsuffix .c, $(TES_FILES)))
TOB		=	$(addprefix $(TES_DIR), $(addsuffix .o, $(TES_FILES)))
OBJF	=	.cache_exists

#############
## RECIPES ##
#############

all:	$(NAME)

test_lexer:	src/minishell.o tests/test_lexer.o
	@$(CC) -lcriterion $^ -o $@

$(NAME):	$(OBJ)
	@echo "$(YELLOW)Linking $(NAME)...$(DEF_COLOR)"
	@$(CC) $(FLAGS) $(OBJ) $(LFLAGS) -o $(NAME)
	@echo "$(GREEN)$(NAME) compiled!$(DEF_COLOR)"

$(BLD_DIR)%.o:	$(SRC_DIR)%.c | $(OBJF)
	@echo "$(YELLOW)Compiling $<$...$(DEF_COLOR)"
	@$(CC) $(FLAGS) -c $< -o $@
	@echo "$(MAGENTA)$<$  compiled!$(DEF_COLOR)"

$(OBJF):
	@echo "$(YELLOW)Creating object directory...$(DEF_COLOR)"
	@mkdir -p $(BLD_DIR)
	@mkdir -p $(addprefix $(BLD_DIR), $(dir $(SRC_FILES)))
	@touch $(OBJF)
	@echo "$(MAGENTA)Object directory created!$(DEF_COLOR)"

clean:
	@rm -rf $(BLD_DIR) $(OBJF)

fclean:	clean
	@rm -f $(NAME)

re: fclean all

-include $(OBJ:.o=.d)

.PHONY:	all clean fclean re