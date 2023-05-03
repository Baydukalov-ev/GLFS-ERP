
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура бг_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	бг_ДобавитьЭлементыФормы();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура бг_ДобавитьЭлементыФормы()

	бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(ЭтотОбъект, "бг_ФормируетсяВручную",
		ЭтотОбъект, "Объект.бг_ФормируетсяВручную");
	Элементы.Переместить(Элементы["бг_ФормируетсяВручную"], ЭтотОбъект, Элементы.ГруппаНазначение);

КонецПроцедуры

&ИзменениеИКонтроль("ДеревоОперандовКонструктораФормул")
&НаСервере
Функция бг_ДеревоОперандовКонструктораФормул()

	Дерево = РаботаСФормулами.ПолучитьПустоеДеревоОперандов();

	ТипСобытийОповещений = Объект.ТипСобытия;
	МакетСКД = Перечисления.ТипыСобытийОповещений.ПолучитьМакет(
		ТипСобытийОповещений.Метаданные().ЗначенияПеречисления.Получить(Перечисления.ТипыСобытийОповещений.Индекс(ТипСобытийОповещений)).Имя);

	ДопОграничения = РаботаСФормулами.ОграниченияРазверткиОперандов();
	ДопОграничения.РекурсивноРазворачиватьОперандыСхемыКомпоновки = Ложь;
#Вставка
	ДопОграничения.РекурсивноРазворачиватьОперандыСхемыКомпоновки = Истина;
#КонецВставки

	ТипыЭлементов = РаботаСФормулами.ТипыЭлементовДереваОперандов();

	ГруппаСтрок = РаботаСФормулами.НоваяСтрокаДереваОперанда(Дерево);
	ГруппаСтрок.Идентификатор = "ПредыдущееСообщение";
	ГруппаСтрок.Представление = НСтр("ru = 'Предыдущее сообщение';
									|en = 'Previous message'");
	ГруппаСтрок.ТипЭлементаДерева = ТипыЭлементов.ГруппаСтрокВерхнегоУровня;
	ГруппаСтрок.РазрешаетсяВыборОперанда = Ложь;
	ГруппаСтрок.ВключаетсяВИдентификатор = Истина;

	РаботаСФормулами.ДобавитьВДеревоДоступныеПоляПоСхемеКомпоновки(ГруппаСтрок, МакетСКД, ДопОграничения);


	ГруппаСтрок = РаботаСФормулами.НоваяСтрокаДереваОперанда(Дерево);
	ГруппаСтрок.Идентификатор = "ТекущееСообщение";
	ГруппаСтрок.Представление = НСтр("ru = 'Текущее сообщение';
									|en = 'Current message'");
	ГруппаСтрок.ТипЭлементаДерева = ТипыЭлементов.ГруппаСтрокВерхнегоУровня;
	ГруппаСтрок.РазрешаетсяВыборОперанда = Ложь;
	ГруппаСтрок.ВключаетсяВИдентификатор = Истина;

	РаботаСФормулами.ДобавитьВДеревоДоступныеПоляПоСхемеКомпоновки(ГруппаСтрок, МакетСКД, ДопОграничения);


	АдресХранилища = ПоместитьВоВременноеХранилище(Дерево, УникальныйИдентификатор);
	Возврат АдресХранилища;

КонецФункции

#КонецОбласти