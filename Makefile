
LUA     := lua
VERSION := $(shell cd src && $(LUA) -e "m = require [[Test.LongString]]; print(m._VERSION)")
TARBALL := lua-testlongstring-$(VERSION).tar.gz
ifndef REV
  REV   := 1
endif

ifndef DESTDIR
  DESTDIR := /usr/local
endif
BINDIR  := $(DESTDIR)/bin
LIBDIR  := $(DESTDIR)/share/lua/5.1

install:
	mkdir -p $(LIBDIR)/Test
	cp src/Test/LongString.lua      $(LIBDIR)/Test

uninstall:
	rm -f $(LIBDIR)/Test/LongString.lua

manifest_pl := \
use strict; \
use warnings; \
my @files = qw{MANIFEST}; \
while (<>) { \
    chomp; \
    next if m{^\.}; \
    next if m{^doc/\.}; \
    next if m{^doc/google}; \
    next if m{^rockspec/}; \
    push @files, $$_; \
} \
print join qq{\n}, sort @files;

rockspec_pl := \
use strict; \
use warnings; \
use Digest::MD5; \
open my $$FH, q{<}, q{$(TARBALL)} \
    or die qq{Cannot open $(TARBALL) ($$!)}; \
binmode $$FH; \
my %config = ( \
    version => q{$(VERSION)}, \
    rev     => q{$(REV)}, \
    md5     => Digest::MD5->new->addfile($$FH)->hexdigest(), \
); \
close $$FH; \
while (<>) { \
    s{@(\w+)@}{$$config{$$1}}g; \
    print; \
}

version:
	@echo $(VERSION)

CHANGES:
	perl -i.bak -pe "s{^$(VERSION).*}{q{$(VERSION)  }.localtime()}e" CHANGES

tag:
	git tag -a -m 'tag release $(VERSION)' $(VERSION)

doc:
	git read-tree --prefix=doc/ -u remotes/origin/gh-pages

MANIFEST: doc
	git ls-files | perl -e '$(manifest_pl)' > MANIFEST

$(TARBALL): MANIFEST
	[ -d lua-TestLongString-$(VERSION) ] || ln -s . lua-TestLongString-$(VERSION)
	perl -ne 'print qq{lua-TestLongString-$(VERSION)/$$_};' MANIFEST | \
	    tar -zc -T - -f $(TARBALL)
	rm lua-TestLongString-$(VERSION)
	rm -rf doc
	git rm doc/*

dist: $(TARBALL)

rockspec: $(TARBALL)
	perl -e '$(rockspec_pl)' rockspec.in > rockspec/lua-testlongstring-$(VERSION)-$(REV).rockspec

check: test

test:
	cd src && prove --exec=$(LUA) ../test/*.t

coverage:
	rm -f src/luacov.stats.out src/luacov.report.out
	cd src && prove --exec="$(LUA) -lluacov" ../test/*.t
	cd src && luacov

clean:
	rm -rf doc
	rm -f MANIFEST *.bak src/luacov.*.out

.PHONY: test rockspec CHANGES

