# Output to out/ directory
$out_dir = "out";

# Ensure .pdf version is generated
$pdf_mode = 1;

# Compile main document by default
@default_files = ("HardwareNN.tex");

# Ensure generation of .glstex file
push @generated_exts, 'glstex', 'glg';
add_cus_dep('aux', 'glstex', 0, 'run_bib2gls');

sub run_bib2gls {
	if($silent) {
		my $ret = system "bib2gls --silent --group '$_[0]'";
	} else {
		my $ret = system "bib2gls --group '$_[0]'";
	};

	my ($base, $path) = fileparse($_[0]);
	if($path && -e "$base.glstex") {
		rename "$base.glstex", "$path$base.glstex";
	}

	# Analyze log file.
	local *LOG;
	$LOG = "$_[0].glg";

	if(!$ret && -e $LOG) {
		open LOG, "<$LOG";
		while(<LOG>) {
			if(/^Reading (.*\.bib)\s$/) {
				rdb_ensure_file( $rule, $1 );
			}
		}
		close LOG;
	}

	return $ret;
}
