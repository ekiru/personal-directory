APPDIR=$(PERSONAL)/applications
PLAN9=$(APPDIR)/plan9

update: pull install

pull: pull-plan9

pull-plan9: $(PLAN9)
	cd $(PLAN9); hg pull -u

install: install-plan9

install-plan9:
	cd $(PLAN9)/src; mk install

$(PLAN9):
	hg clone http://code.swtch.com/plan9port $(PLAN9); \
	cd $(PLAN9); ./INSTALL
