#Область ПрограммныйИнтерфейс

// Возвращает транспортые средства, в экипаж которых входит сотрудник
//
// Возвращаемое значение:
//   Массив - ПеречислениеСсылка.бг_ЧленыЭкипажа - члены экипажа, которые являются водителями
//
Функция Водители() Экспорт
	Результат = Новый Массив;
	Результат.Добавить(Перечисления.бг_ЧленыЭкипажа.ОсновнойВодитель);
	Результат.Добавить(Перечисления.бг_ЧленыЭкипажа.ВторойВодитель);
	Возврат Результат;
КонецФункции

#КонецОбласти