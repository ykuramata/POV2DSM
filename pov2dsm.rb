=begin
	B-Spline Curve Processer POV2DSM (PovRay to DesignSpark Mechanical)

	Usage:
	1. Prepare a PovRay(*.pov) file. (I used Inkscape)
	2. Type '$ruby pov2dsm.rb YOUR_FILENAME' on console.
	3. A text file (which contains points calicurated from path) will be created.
	4. On DesignSparkMechanical, import the created text file as a point curve text file.

	Y.Kuramata March 2016
	http://enthusiastickcoding.blogspot.jp/
	http://enthusiastickmaking.blogspot.jp/
  License: Public Domain

 THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
 IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL ANY COPYRIGHT HOLDER,  OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
=end

if ARGV.length <1
	exit
end
ifilename = ARGV[0]
ofilename = ARGV[0].gsub(/pov/,"txt")
STEP = 0.05 #Decrease STEP when you need more points.
$ofile = File.open(ofilename, "w")
$ifile = File.open(ifilename)

$ofile.puts <<EOS
3d=true
polyline=false
EOS

def process_prism
	while line = $ifile.gets
		if line.match(/.*<.*>.*/)
			a = Array.new
			line.scan(/<.*?>/).each{|e1|
				e1.sub(/</, "").sub(/>/,"").split(",").each{|e2|
					a << e2.to_f
			}}
			x1 = a[0]
			y1 = a[1]
			x2 = a[2]
			y2 = a[3]
			x3 = a[4]
			y3 = a[5]
			x4 = a[6]
			y4 = a[7]
			t = 0.0
		 	while t < 1.0
				x = t**3*x4 + 3.0*t**2*(1.0-t)*x3 + 3.0*t*(1.0-t)**2*x2 + (1.0-t)**3*x1
				y = t**3*y4 + 3.0*t**2*(1.0-t)*y3 + 3.0*t*(1.0-t)**2*y2 + (1.0-t)**3*y1
				$ofile.puts 0.to_s + "\t" +x.to_s + "\t" +y.to_s
				t += STEP
			end
		end
		break if line.match(/.*}.*/)
	end
	$ofile.puts
end

while line = $ifile.gets
	if line.match(/.*declare.*prism.*/)
		process_prism
	end
end

$ofile.close
$ifile.close
