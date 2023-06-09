
#Область ОбработчикиСобытийФормы
	
&НаСервере
&После("ПриСозданииНаСервере")
Процедура бг_ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	бг_ДобавитьЭлементФормыПунктНазначения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
&После("ТипПервичногоДокументаПриИзмененииСервер")
Процедура бг_ТипПервичногоДокументаПриИзмененииСервер()
	
	бг_УстановитьВидимостьПунктаНазначения();
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьЭлементФормыПунктНазначения()
	
	бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтаФорма,
		"бг_ПунктНазначения",
		Элементы.ГруппаШапкаЛево,
		"Объект.бг_ПунктНазначения",
		"ПолеФормы",
		Элементы.ГруппаСуммаДокумента);
	
	бг_УстановитьВидимостьПунктаНазначения();
	
КонецПроцедуры

&НаСервере
Процедура бг_УстановитьВидимостьПунктаНазначения()
	
	Элементы.бг_ПунктНазначения.Видимость = Объект.ТипПервичногоДокумента =
		ПредопределенноеЗначение("Перечисление.ТипыПервичныхДокументов.РеализацияКлиенту");
	
КонецПроцедуры

#КонецОбласти
