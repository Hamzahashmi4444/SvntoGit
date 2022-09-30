# makefile for cytoscape/experiment/connection/unitTests
#-------------------------------------------------------------------------
# $Revision: 4023 $
# $Date: 2005-10-12 05:57:44 +0000 (Wed, 12 Oct 2005) $
# $Author: edeutsch $
#--------------------------------------------------------------------

JC=javac

PKG=SBEAMS.unitTests

.SUFFIXES: .java .class
.java.class: 
	$(JC) $<

OBJS = SBEAMSClientTest.class

default: objs

objs: $(OBJS)

test: objs 0

all: objs

#------ 0
#  build and run the SBEAMSClientTest
#
0: SBEAMSClientTest.class
	java $(PKG).SBEAMSClientTest

clean:
	- rm *.class
