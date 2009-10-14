
VERSION := $(shell cd src && lua -e "require [[Test.LongString]]; print(Test.LongString._VERSION)")
TARBALL := lua-testlongstring-$(VERSION).tar.gz
ifndef REV
  REV   := 1
endif

manifest_pl := \
use strict; \
use warnings; \
my @files = qw{MANIFEST}; \
while (<>) { \
    chomp; \
    next if m{^\.}; \
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

MANIFEST:
	git ls-files | perl -e '$(manifest_pl)' > MANIFEST

$(TARBALL): MANIFEST
	[ -d lua-TestLongString-$(VERSION) ] || ln -s . lua-TestLongString-$(VERSION)
	perl -ne 'print qq{lua-TestLongString-$(VERSION)/$$_};' MANIFEST | \
	    tar -zc -T - -f $(TARBALL)
	rm lua-TestLongString-$(VERSION)

dist: $(TARBALL)

rockspec: $(TARBALL)
	perl -e '$(rockspec_pl)' rockspec.in > rockspec/lua-testlongstring-$(VERSION)-$(REV).rockspec

export LUA_PATH=;;./src/?.lua
test:
	prove --exec=lua test/*.t

html:
	xmllint --noout --valid doc/*.html

clean:
	rm -f MANIFEST *.bak

.PHONY: test rockspec CHANGES

