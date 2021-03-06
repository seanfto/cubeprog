CXXFLAGS = -DHALF -O4 -Wall -DLEVELCOUNTS

.SUFFIXES: .w .tex .pdf

default: all

WEBSOURCES = cubepos.w kocsymm.w phase1prune.w phase2prune.w twophase.w hcoset.w

CFILES = cubepos.h cubepos.cpp cubepos_test.cpp kocsymm.h kocsymm.cpp \
   kocsymm_test.cpp phase1prune.h phase1prune.cpp phase1prune_test.cpp \
   phase2prune.h phase2prune.cpp phase2prune_test.cpp twophase.cpp hcoset.cpp

HSOURCES = bestsol.h corner_order.h

MISCSOURCES = makefile twophase.html hcoset.html index.html

SOURCES = $(WEBSOURCES) $(HSOURCES) $(MISCSOURCES)

BINARIES = twophase hcoset

TESTBINARIES = cubepos_test kocsymm_test phase2prune_test phase1prune_test

PDFS = cubepos.pdf kocsymm.pdf phase2prune.pdf phase1prune.pdf twophase.pdf hcoset.pdf

all: $(BINARIES) $(TESTBINARIES) $(PDFS)

test: $(TESTBINARIES)
	./cubepos_test && ./kocsymm_test && ./phase2prune_test && ./phase1prune_test

clean:
	rm -f $(BINARIES)
	rm -f $(TESTBINARIES)
	rm -f $(CFILES)
	rm -f $(PDFS)
	rm -f *.idx *.toc
	rm -f cubepos.tex hcoset.tex kocsymm.tex phase1prune.tex phase2prune.tex twophase.tex
	rm -f *.log *.scn
	rm -f *.c

dist:
	rm -rf dist
	mkdir dist
	cp $(SOURCES) dist
	tar czf dist.tar.gz dist

bigdist:
	rm -rf bigdist
	mkdir bigdist
	cp $(SOURCES) $(PDFS) $(CFILES) bigdist
	tar czf bigdist.tar.gz bigdist

.w.cpp: ; ctangle $*

.w.tex: ; cweave $*

.tex.pdf: ; pdftex $*

.w.pdf: ; cweave $* && pdftex $*

cubepos.cpp cubepos.h cubepos_test.cpp: cubepos.w

kocsymm.cpp kocsymm.h kocsymm_test.cpp: kocsymm.w

phase2prune_test.cpp phase2prune.cpp phase2prune.h: phase2prune.w

phase1prune_test.cpp phase1prune.cpp phase1prune.h: phase1prune.w

cubepos_test: cubepos.cpp cubepos.h cubepos_test.cpp
	$(CXX) $(CXXFLAGS) -o cubepos_test cubepos_test.cpp cubepos.cpp

kocsymm_test: kocsymm.cpp kocsymm.h kocsymm_test.cpp cubepos.h cubepos.cpp
	$(CXX) $(CXXFLAGS) -o kocsymm_test kocsymm_test.cpp kocsymm.cpp cubepos.cpp

phase2prune_test: phase2prune_test.cpp phase2prune.cpp phase2prune.h kocsymm.cpp kocsymm.h cubepos.h cubepos.cpp
	$(CXX) $(CXXFLAGS) -o phase2prune_test phase2prune_test.cpp phase2prune.cpp kocsymm.cpp cubepos.cpp

phase1prune_test: phase1prune_test.cpp phase1prune.cpp phase1prune.h kocsymm.cpp kocsymm.h cubepos.h cubepos.cpp
	$(CXX) $(CXXFLAGS) -o phase1prune_test phase1prune_test.cpp phase1prune.cpp kocsymm.cpp cubepos.cpp

twophase: twophase.cpp phase1prune.cpp phase1prune.h phase2prune.cpp phase2prune.h kocsymm.cpp kocsymm.h cubepos.cpp cubepos.h
	$(CXX) $(CXXFLAGS) -o twophase twophase.cpp phase1prune.cpp phase2prune.cpp kocsymm.cpp cubepos.cpp -lpthread

hcoset: hcoset.cpp phase1prune.cpp phase1prune.h kocsymm.cpp kocsymm.h cubepos.cpp cubepos.h bestsol.h corner_order.h
	$(CXX) $(CXXFLAGS) -o hcoset hcoset.cpp phase1prune.cpp kocsymm.cpp cubepos.cpp -lpthread
