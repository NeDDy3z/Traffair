extends Button

## Array of advices constant
const advice = [
	"Remember that spiders are more afraid of you, than you are of them.",
	"Smile and the world smiles with you. Frown and you're on your own.",
	"Don't eat non-snow-coloured snow.",
	"Cars are bad investments.",
	"If you have the chance, take it!",
	"Never cut your own fringe.",
	"Make choices and dont look back.",
	"Happiness is a journey, not a destination.",
	"True happiness always resides in the quest.",
	"Never pay full price for a sofa at DFS.",
	"Avoid mixing Ginger Nuts with other biscuits, they contaminate. Keep separated.",
	"Always block trolls.",
	"If you're feeling tired or anxious, a pint of water will almost always make you feel better.",
	"Life is better when you sing about bananas.",
	"If it ain't broke don't fix it.",
	"It's unlucky to be superstitious.",
	"Sometimes it's best to ignore other people's advice.",
	"Don't judge a book by its cover, unless it has a synopsis on the back.",
	"If you cannot unscrew the lid of a jar, try placing a rubber band around its circumference for extra grip.",
	"Don't put off breaking up with someone when you know you want to. Prolonging the situation only makes it worse.",
	"Don't feed Mogwais after midnight.",
	"Your smile could make someone's day, don't forget to wear it.",
	"When the cistern is filling, the seat is probably still warm.",
	"Never buy cheap cling film.",
	"Don't cross the streams.",
	"Don't wear clean trousers when walking your dog in the park.",
	"When you're looking up at birds flying overhead, keep your mouth closed.",
	"As you get older, learn never to trust a fart.",
	"When in doubt, just take the next small step.",
	"Never let your Mother cut your hair.",
	"Everything in moderation, including moderation itself.",
	"Don't let the bastards grind you down.",
	"To improve productivity, always have a shittier task to put off.",
	"Only those who attempt the impossible can achieve the absurd.",
	"If you think nobody cares if you're alive, try missing a few payments.",
	"There is no reason at all to believe that White Wine is any different to water when it comes to removing Red Wine stains.",
	"The most delicious cocktails often have the highest alcohol content. Always pace yourself to preserve your dignity.",
	"Never run a marathon in Crocs.",
	"Never run with scissors.",
	"Don't use Excel or Powerpoint documents for your basic word processing needs.",
	"Always double check you actually attached the file to the email.",
	"Try to pay at least one person a compliment every day.",
	"If you are feeling down, try holding a pencil between your top lip and your nose for five minutes.",
	"Build something out of LEGO.",
	"Try going commando to an important meeting, NB: don't wear a skirt.",
	"If you need cheering up, try searching online for photos of kittens.",
	"A long walk alone with some time to think, can work wonders.",
	"Walking is a perfectly valid solution to traffic congestion problems.",
	"It's wrong to be right.",
	"Don't promise what you can't deliver.",
	"Accentuate the positive, eliminate the negative.",
	"The more ideas that you give away, the more ideas that will come to you.",
	"Do not seek praise, seek criticism.",
	"Try to do the things that you're incapable of.",
	"If you get stuck, try doing the opposite of what the solution requires.",
	"Don't give a speech. Put on a show.",
	"Don't be afraid of silly ideas.",
	"Fail. Fail again. Fail better.",
	"Once in a while, eat some sweets you used to enjoy when you were younger.",
	"Giving someone a hug can be mutually rewarding. Try to give at least one hug a day to someone.",
	"If you're squashed close to strangers on public transport, try not to be rude to them. No one likes those situations.",
	"You don't need to floss all of your teeth. Only the ones you want to keep.",
	"When having a clear out, ask yourself if an item has any financial, practical or sentimental value. If not, chuck it.",
	"Take time once in a while to look up at the stars for at least 5 minutes, in order to comprehend your cosmic significance.",
	"The number of vampires in the average home, is directly proportional to the amount of garlic bread in the fridge.",
	"Visitors are like fish: As much as you might like them, after three days they start to smell.",
	"Don't try and bump start a motorcycle on an icy road.",
	"It is easy to sit up and take notice, what's difficult is getting up and taking action.",
	"Don't eat anything your grandparents wouldn't recognise as food.",
	"Eat food. Not too much, mostly plants.",
	"Work is never as important as you think it is.",
	"You will always regret the round of Tequila.",
	"You will always regret the round of JÃ¤germeister.",
	"Mercy is the better part of justice.",
	"Being kind is more rewarding than being right.",
	"Just because you are offended, doesn't mean you are right.",
	"Opinions are like arseholes, everyone has one.",
	"Age is of no importance, unless you are a cheese.",
	"For every complex problem there is an answer that is clear, simple, and wrong.",
	"Put a piece of kitchen roll in with your bag of leaves to make them last longer.",
	"Never set an alarm clock unless you know how to switch it off",
	"If you don't want something to be public, don't post it on the Internet.",
	"Never write in an email to someone, something which you wouldn't say to that person's face.",
	"Turn jeans inside out when washing them to help preserve their colour.",
	"Hold the door open for the next person.",
	"Don't be afraid to ask questions.",
	"Brush your teeth the moment you get up.",
	"Drink a glass of water before meals.",
	"You can have too much of a good thing.",
	"The higher up you are in a company, the more likely it is that your boss is a psychopath.",
	"Sometimes, you just need to say sorry. Even if it's not your fault.",
	"Good advice is something a man gives when he is too old to set a bad example.",
	"Don't give to others advice which you wouldn't follow.",
	"If you are ever in doubt about whether or not to wash your hair: Wash it.",
	"It's always the quiet ones.",
	"Learn from your mistakes.",
	"Everybody makes mistakes.",
	"Alway do anything for love, but don't do that.",
	"Tell it like it is.",
	"Respect your elders.",
	"Do, or do not. There is no try.",
	"When you look around and don't see anyone you respect, its time to leave.",
	"A problem shared is a problem halved.",
	"If you don't ask, you don't get.",
	"Don't ever name files or folders using the word \"Final\".",
	"To cleanly remove the seed from an Avocado, lay a knife firmly across it, and twist.",
	"Give up your seat for someone who needs it.",
	"You're not as fat as you think you are.",
	"It's not about who likes you, it's about who you like.",
	"Lemon and salt works wonders on tarnished brass.",
	"Step 1. Give a shit. Step 2. Don't be a dick. Step 3. Know when to let go.",
	"One of the top five regrets people have is that they didn't have the courage to be their true self.",
	"One of the top five regrets people have is that they didn't stay in contact with friends.",
	"A common regret in life is wishing one hadn't worked so hard.",
	"A common regret in life is wishing one had the courage to be ones true self.",
	"Don't assume anything is possible or impossible until you've asked the people who will be doing the work.",
	"A nod is as good as a wink to a blind horse.",
	"If you think your headphones are dying, check the socket for fluff with a straightened paperclip.",
	"You spend half your life asleep or in bed. It's worth spending money on a good mattress, decent pillows and a comfy duvet.",
	"Winter is coming.",
	"Do not check work email on your days off.",
	"Why wait until valentines day for a romantic gesture?",
	"Taking photos with tablet devices looks weird.",
	"When hugging, hug with both arms and apply reasonable, affectionate pressure.",
	"When you're at a concert or event, enjoy the moment, enjoy being there. Try leaving your camera in your pocket.",
	"Stop procrastinating.",
	"If you have grandparents or parents - Talk to them more. Ask them about their life experiences.",
	"YOLO",
	"Repeat people's names when you meet them.",
	"If you find yourself distressed about something, ask yourself if it will still matter tomorrow or next week or next month.",
	"The person who never made a mistake never made anything.",
	"If you want to be happily married, marry a happy person.",
	"Everything matters, but nothing matters that much.",
	"You're not that important; it's what you do that counts.",
	"Keep it simple.",
	"If you're going bald, don't comb your hair over your bald patch.",
	"If your hair is thinning, try dying your hair a similar tone to your scalp.",
	"If you can't do anything about it, there's no point in worrying about it.",
	"If you don't like the opinion you've been given, get another one.",
	"When painting a room, preparation is key. The actual painting should account for about 40% of the work.",
	"Pedantry is fine, unless you're on the receiving end. And not a pedant.",
	"Always the burrito.",
	"Today, do not use the words \"Kind of\", \"Sort of\" or \"Maybe\". It either is or it isn't.",
	"Don't take life too seriously.",
	"Some people would be better off if they took their own advice.",
	"As things get closer to the light, the shadows get darker.",
	"The most important thing is the thing most easily forgotten.",
	"When faced with a choice, do both.",
	"Accept advice.",
	"Try using an old idea.",
	"State the problem in words as clearly as possible.",
	"What could you increase? What could you reduce?",
	"Life is short enough, don't race to the finish.",
	"When something goes wrong in life, just shout \"plot twist!\" and carry on.",
	"Life can be a lot more interesting inside your head.",
	"What's stopping you?",
	"Enjoy a little nonsense now and then.",
	"You have as many hours in a day as the people you admire most.",
	"Stop using the term \"busy\" as an excuse.",
	"Big things have small beginnings.",
	"Some of life's best lessons are learnt at the worst times.",
	"Eliminate the unnecessary.",
	"The quieter you become, the more you can hear.",
	"No one knows anyone else in the way you do.",
	"Do a bit more for your friends.",
	"Do something selfless.",
	"Remedy tickly coughs with a drink of honey, lemon and water as hot as you can take.",
	"If you've nothing nice to say, say nothing.",
	"If it still itches after a week, go to the doctors.",
	"Always bet on black.",
	"Be a good lover.",
	"Plant a tree.",
	"Good things come to those who wait.",
	"Everyone has their down days. Don't take it out on innocent bystanders.",
	"It always seems impossible, until it's done.",
	"Never regret. If it's good, it's wonderful. If it's bad, it's experience.",
	"Never regret. If it's good, it's wonderful. If it's bad, it's experience.",
	"Rule number 1: Try not to die. Rule number 2: Don't be a dick.",
	"Most things look better when you put them in a circle.",
	"Always get two ciders.",
	"You can fail at what you don't want. So you might as well take a chance on doing what you love.",
	"You can fail at what you don't want. So you might as well take a chance on doing what you love.",
	"One of the single best things about being an adult, is being able to buy as much LEGO as you want.",
	"The sun always shines above the clouds.",
	"Measure twice, cut once.",
	"Do not compare yourself with others.",
	"Don't always believe what you think.",
	"Learn to handle criticism.",
	"Don't take it personally.",
	"Value the people in your life.",
	"Don't always rely on your comforts.",
	"Exercise in the rain can really make you feel alive.",
	"Have a firm handshake.",
	"Look people in the eye.",
	"Sing in the shower.",
	"Be brave. Even if you're not, pretend to be. No one can tell the difference.",
	"Sarcasm is the lowest form of wit. Employ correctly with apt timing.",
	"Don't burn bridges.",
	"Never waste an opportunity to tell someone you love them.",
	"The best sex is fun.",
	"The best nights out are when people around you are simply having fun.",
	"Try to not compliment people on things they don't control.",
	"Don't waste food.",
	"Always seek out advice or opinions when making a decision.",
	"Play is the true mother of invention.",
	"Most things done in secrecy are better left undone.",
	"You never really grow up.",
	"No \"brand\" is your friend.",
	"The hardest things to say are usually the most important.",
	"Quality beats quantity.",
	"Things are just things. Don't get too attached to them.",
	"Once you find a really good friend don't do anything that could mess up your friendship.",
	"Try making a list.",
	"Identify sources of happiness.",
	"Gratitude is said to be the secret to happiness.",
	"Try buying a coffee for the creator of a free public API, now and then.",
	"Most things are not as bad as you think they are.",
	"Share positive energy.",
	"Respect other people's opinions, even when they differ from your own.",
	"Vinegar is a powerful cleaning agent.",
	"Don't drink bleach."
]

var text_label : Label
var rng : RandomNumberGenerator



# Called when the node enters the scene tree for the first time.
func _ready():
	## Initialize variables
	text_label = $"../../../../text"
	rng = RandomNumberGenerator.new()
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


## On [Button] press the randomly chosen [advice] will appear in the [text_label] window
func _on_pressed():
	text_label.text = advice[rng.randi_range(0, len(advice)-1)]
	
	
	Logger.write_to_log(name, "show tip", text_label.text)
	Logger.write_to_console(name, "show tip", text_label.text)
