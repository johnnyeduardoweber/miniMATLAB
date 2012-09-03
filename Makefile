LEX=/usr/bin/lex
YACC=/usr/bin/yacc
CC=/usr/bin/gcc
X10C=`which x10c++`

default: backend
	@echo '#!/bin/sh' > miniMATLAB
	@echo 'if [ $$# -lt 1 ] ; then' >> miniMATLAB
	@echo "echo 'Usage: miniMATLAB [filename]'" >> miniMATLAB
	@echo 'exit 0' >> miniMATLAB
	@echo 'fi' >> miniMATLAB
	@echo './frontend $$1' >> miniMATLAB
	@echo './backend $$1 1' >> miniMATLAB
	@chmod 711 miniMATLAB

backend: frontend
	@${X10C} backend.x10 -o backend
	@rm *.cc *.h

frontend:
	@$(LEX) miniMATLAB.l
	@$(YACC) miniMATLAB.y
	@$(CC) -o frontend y.tab.c -ll 
	@rm y.tab.c lex.yy.c

functests:
	@${X10C} test/phase1.x10 -o test1
	@${X10C} test/phase2.x10 -o test2
	@${X10C} test/phase3.x10 -o test3
	@rm *.cc *.h
	@echo "---------- PHASE 1 ------------"
	@./test1
	@echo "---------- PHASE 2 ------------"
	@./test2
	@echo "---------- PHASE 3 ------------"
	@./test3
	@rm test1 test2 test3

perftests:
	@${X10C} test/perf.x10 -o perf
	@echo "-------- PERFORMANCE ----------"
	@./perf 
	@rm perf
	
clean:
	@find . -name frontend -print | xargs -r rm
	@find . -name backend -print | xargs -r rm
	@find . -name miniMATLAB -print |xargs -r rm
	@find . -name \*.cc -print |xargs -r rm
	@find . -name \*.h -print |xargs -r rm
	@find . -name \*.java -print |xargs -r rm
	@find . -name \*.class -print |xargs -r rm
